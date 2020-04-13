import json

import pandas as pd

from pytz import timezone, utc
from datetime import datetime
import uuid
import time

#
# last_session_df = last_session_df.set_index(['userId', 'session'])
# words_df = signals_df.set_index(['userId', 'session']).join(last_session_df, how='inner')
# # words_df = words_df.query('signal == 0')
# # filter last session and unknown
# count_df = signals_df.reset_index().drop_duplicates(['word', 'i']).groupby(['userId', 'session', 'word']).agg(
#     count=('i', 'count'))
# .drop_duplicates(['word'])
# .reset_index().

from dataserver.models.dataframe import ReviewDataFrame

def serialize_review_words_df(words_df, clean_pages_df, target_df):
    words_df = words_df[['userId', 'word', 'pageId', 'priority']]
    words_df = words_df.set_index(['userId', 'pageId'])

    items_df = clean_pages_df.set_index(['userId', 'pageId'])[['itemsJson']]

    combined_df = words_df.join(items_df, how='inner')
    combined_df = combined_df.reset_index()[['userId', 'word', 'priority', 'itemsJson']]

    def serialize(df):
        out = []
        for _, row in df.iterrows():
            item = {
                'word': row['word'],
                'items': json.loads(row['itemsJson'])
            }
            out.append(item)
        return pd.Series({'reviewWords': json.dumps(out)})

    combined_df = combined_df.sort_values(['userId', 'priority'], ascending=False)

    combined_df = combined_df \
        .reset_index() \
        .groupby(['userId']) \
        .apply(serialize) \
        .reset_index()

    combined_df = combined_df.set_index(['userId'])
    target_df = target_df.set_index(['userId'])
    combined_df = combined_df.join(target_df)\
        .reset_index()

    return combined_df

def serialize_stats_df(session_info_df):
    stats_df = session_info_df.copy()

    from dataserver.job.utils import parse_kst_date_from_ts

    def serialize(df):
        lastReadWords = []
        wpm = []
        hours = []
        for _, row in df.iterrows():
            date = parse_kst_date_from_ts(row['start'])
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

    return stats_df \
        .sort_values(['userId', 'session']) \
        .groupby(['userId']) \
        .apply(serialize) \
        .reset_index()

def combine_serialized_dfs(stats_df, review_words_df, last_session_df, session_info_df):
    last_session_df = last_session_df.set_index(['userId', 'session'])
    time_df = session_info_df.set_index(['userId', 'session'])[['start', 'end']]
    combined_df = last_session_df.join(time_df, how='inner').reset_index()
    del combined_df['session']

    combined_df = combined_df.set_index(['userId'])
    review_words_df = review_words_df.set_index(['userId'])
    combined_df = combined_df.join(review_words_df, how='inner').reset_index()

    combined_df = combined_df.set_index(['userId'])
    stats_df = stats_df.set_index(['userId'])
    combined_df = combined_df.join(stats_df, how='left').reset_index()

    def combine(row):
        stats = None if pd.isnull(row['stats']) else json.loads(row['stats'])
        out = {
            'id': str(uuid.uuid4()),
            'stats': stats,
            'time': time.time(),
            'reviewWords': json.loads(row['reviewWords']),
            'targetReviewWords': row['targetReviewWords'],
            'start': row['start'],
            'end': row['end']
        }
        return pd.Series({'review': json.dumps(out)})

    combined_df = combined_df \
        .reset_index() \
        .set_index('userId') \
        .apply(combine, axis=1) \
        .reset_index()

    return ReviewDataFrame.validate(combined_df)