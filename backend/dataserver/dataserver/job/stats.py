import json
import time
import pandas as pd
import typing

from pytz import timezone, utc
from datetime import datetime

from dataserver.models.dataframe import SessionInfoDataFrame, LastSessionDataFrame
from dataserver.models.vocab_skill import VocabSkill
from dataserver.service.user import UserService
from dataserver.service.nlp import NLPService

def extract_session_info_df(signals_df, clean_pages_df):
    df = signals_df.groupby(['userId', 'session']) \
        .agg(start=('time', 'min'),
             end=('time', 'max'),
             nwords=('signal', 'sum'),
             readWords=('word', 'count'))
    df['unknownWords'] = (df['readWords'] - df['nwords']).astype('int64')
    del df['nwords']

    clean_pages_df = clean_pages_df.copy()
    df2 = clean_pages_df.groupby(['userId', 'session']) \
        .agg(wpm=('wpm', 'mean'),
             eltime=('eltime', 'sum'))
    df2['hours'] = (df2['eltime']) / (60 * 60)
    del df2['eltime']

    df3 = df.join(df2).reset_index()
    return SessionInfoDataFrame.validate(df3)


def extract_last_session_df(session_info_df, user_service: UserService, last_words_after_hours: float,
                         skip_session_hours: float):
    def _extract_last_session(df):
        for index, row in df[::-1].iterrows():
            userId = row['userId']
            user = user_service.get_user(userId)
            if user is None:
                return pd.Series({'session': -1, 'end': 0})
            if 'lastReviewEnd' in user and user['lastReviewEnd'] >= row['end']:
                return pd.Series({'session': -1, 'end': 0})
            if (time.time() - row['start']) < last_words_after_hours * 60 * 60:
                continue
            if row['hours'] <= skip_session_hours:
                continue
            return pd.Series({'session': row['session'], 'end': row['end']})
        return pd.Series({'session': -1, 'end': 0})

    last_session_df = session_info_df.groupby('userId') \
        .apply(_extract_last_session) \
        .dropna() \
        .reset_index()
    if len(last_session_df) != 0:
        last_session_df['session'] = last_session_df['session'].astype('int64')

    return LastSessionDataFrame.validate(last_session_df)

def calculate_vocab_skills(known_words_df, vocabs: typing.List[VocabSkill]):
    out = []
    userIds = known_words_df['userId'].unique()
    for vocab in vocabs:
        raw_words_df = pd.DataFrame([{'word': word} for word in vocab.words])
        for userId in userIds:
            words_df = raw_words_df.copy()
            df = known_words_df.copy()
            df = df.loc[df['userId'] == userId]

            words_df = words_df.set_index('word')
            df = df.set_index('word')
            words_df = words_df.join(df, how='left')
            perc = ((~words_df.isnull()).sum() / len(words_df))[0]
            out.append({
                'userId': userId,
                'name': vocab.name,
                'perc': perc
            })
    return pd.DataFrame(out)

# start = time.time() - self.last_stats_days * 24 * 60 * 60
#    .loc[(start < stats_df['start']) & (stats_df['end'] < end)]
#     end = time.time()
