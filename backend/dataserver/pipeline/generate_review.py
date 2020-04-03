from gorani.utils import split_sentence, unnesting
from metaflow import FlowSpec, step, Flow, IncludeFile
import pandas as pd
import json
import uuid
import typing
import numpy as np
from gorani.booky import Book
from pandas import DataFrame
from firebase_admin import credentials
from firebase_admin import firestore
import firebase_admin
import time
from datetime import datetime, timedelta
from pytz import timezone, utc
import pandera as pa

LastSessionDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "session": pa.Column(pa.Int),
}, strict = True)

LastWordsDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "session": pa.Column(pa.Int),
    "lastWords": pa.Column(pa.String),
    "targetLastWords": pa.Column(pa.Int)
}, strict = True)

StatsDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "stats": pa.Column(pa.String)
}, strict = True)

ReviewDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "review": pa.Column(pa.String)
}, strict = True)

class GenerateReview(FlowSpec):
    firebase_key = IncludeFile(
        'firebase-key',
        is_text=False,
        help='Firebase Key File',
        default='./firebase-key.json')

    @step
    def start(self):
        flow = Flow('DownloadLog').latest_successful_run
        print('using data from flow: %s' % flow.id)
        self.users = flow.data.users

        flow = Flow('PreprocessPaginate').latest_successful_run
        print('using data from flow: %s' % flow.id)
        self.session_info_df = flow.data.session_info_df
        self.clean_pages_df = flow.data.clean_pages_df
        self.signals_df = flow.data.signals_df
        self.last_words_after_hours = 12
        self.skip_session_hours = 0.1
        self.last_stats_days = 14

        self.next(self.preprocess)

    @step
    def preprocess(self):
        last_words_after_hours = self.last_words_after_hours
        skip_session_hours = self.skip_session_hours

        session_info_df = self.session_info_df.copy()
        users = self.users

        def extract_last_session(df):
            for index, row in df[::-1].iterrows():
                userId = row['userId']
                if userId not in users:
                    return None
                user = users[userId]
                if 'lastReviewEnd' in user and user['lastReviewEnd'] >= row['end']:
                    return None
                if (time.time() - row['start']) < last_words_after_hours * 60 * 60:
                    continue
                if row['hours'] <= skip_session_hours:
                    continue
                return pd.Series({'session': row['session']})
            return None
        last_session_df = session_info_df.groupby('userId') \
            .apply(extract_last_session) \
            .dropna()\
            .reset_index()
        last_session_df['session'] = last_session_df['session'].astype('int64')

        self.last_session_df = LastSessionDataFrame.validate(last_session_df)
        self.next(self.extract_last_words_df)

    @step
    def extract_last_words_df(self):
        last_session_df = self.last_session_df.copy()
        signals_df = self.signals_df.copy()
        clean_pages_df = self.clean_pages_df.copy()

        # filter last session and unknown
        last_session_df = last_session_df.set_index(['userId', 'session'])
        words_df = signals_df.set_index(['userId', 'session']).join(last_session_df, how='inner')
        words_df = words_df.query('signal == 0')

        count_df = words_df.reset_index().drop_duplicates(['word', 'i']).groupby(['userId', 'session', 'word']).agg(
            count=('i', 'count'))

        words_df = words_df.drop_duplicates(['word']).reset_index().set_index(['userId', 'session', 'i'])
        items_df = clean_pages_df.set_index(['userId', 'session', 'i'])[['itemsJson']]
        combined_df = words_df.join(items_df, how='inner')

        combined_df = combined_df.reset_index()[['userId', 'session', 'word', 'itemsJson']]
        combined_df = combined_df.set_index(['userId', 'session', 'word']).join(count_df)

        def combine_last_words(df):
            out = []
            for _, row in df.iterrows():
                item = {
                    'word': row['word'],
                    'items': json.loads(row['itemsJson'])
                }
                out.append(item)
            return pd.Series({'lastWords': json.dumps(out), 'targetLastWords': min(len(out), 100)})
        combined_df = combined_df.sort_values(['userId', 'count'], ascending=False)
        combined_df = combined_df\
            .reset_index()\
            .groupby(['userId', 'session'])\
            .apply(combine_last_words)\
            .reset_index()

        self.last_words_df = LastWordsDataFrame.validate(combined_df)
        self.next(self.extract_stats_df)

    @step
    def extract_stats_df(self):
        KST = timezone('Asia/Seoul')
        start = time.time() - self.last_stats_days * 24 * 60 * 60
        end = time.time()
        stats_df = self.session_info_df.copy()

        def combine_stats(df):
            lastReadWords = []
            wpm = []
            hours = []
            for _, row in df.iterrows():
                date = utc.localize(datetime.utcfromtimestamp(row['start']))
                date = date.astimezone(KST)
                x = date.strftime('%m-%d')
                lastReadWords.append({'time': x, 'y': row['readWords']})
                wpm.append({'time': x, 'y': row['wpm']})
                hours.append({'time': x, 'y': row['hours']})
            out = {
                'lastReadWords': lastReadWords,
                'wpm': wpm,
                'hours': hours
            }
            return pd.Series({'stats': json.dumps(out)})

        stats_df = stats_df.loc[(start < stats_df['start']) & (stats_df['end'] < end)] \
            .sort_values(['userId', 'session']) \
            .groupby(['userId'])\
            .apply(combine_stats)\
            .reset_index()

        self.stats_df = StatsDataFrame.validate(stats_df)
        self.next(self.combine_df)

    @step
    def combine_df(self):
        stats_df = self.stats_df.copy()
        last_words_df = self.last_words_df.copy()
        session_info_df = self.session_info_df.copy()


        time_df = session_info_df.set_index(['userId', 'session'])[['start', 'end']]
        combined_df = last_words_df\
            .set_index(['userId', 'session'])\
            .join(time_df, how='inner')\
            .reset_index()\
            .set_index('userId')
        del combined_df['session']

        stats_df = stats_df.set_index(['userId'])
        combined_df = combined_df.join(stats_df)

        def combine(row):
            stats = None if pd.isnull(row['stats']) else json.loads(row['stats'])
            out = {
                'id': str(uuid.uuid4()),
                'stats': stats,
                'lastWords': json.loads(row['lastWords']),
                'unfamiliarWords': [],
                'texts': [],
                'targetLastWords': row['targetLastWords'],
                'start': row['start'],
                'end': row['end'],
                'targetCompletedTexts': 0
            }
            return pd.Series({'review': json.dumps(out)})
        combined_df = combined_df\
            .reset_index()\
            .set_index('userId')\
            .apply(combine, axis=1)\
            .reset_index()

        self.review_df = ReviewDataFrame.validate(combined_df)
        self.next(self.upload)

    @step
    def upload(self):
        with open('/tmp/firebase-key.json', 'wb') as f:
            f.write(self.firebase_key)
        cred = credentials.Certificate('/tmp/firebase-key.json')
        firebase_admin.initialize_app(cred, {
            'projectId': "gorani-reader-249509",
        })

        db = firebase_admin.firestore.client()

        for _, row in self.review_df.iterrows():
            ref = db.collection('users').document(row['userId'])
            ref.set({
                'review': json.loads(row['review'])
            }, merge=True)

        self.next(self.end)

    @step
    def end(self):
        print(self.review_df)

if __name__ == '__main__':
    GenerateReview()