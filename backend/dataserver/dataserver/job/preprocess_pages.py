import pandera as pa
import pandas as pd

import numpy as np

from dataserver.booky.book import split_sentence, Book
from dataserver.job.utils import unnesting
from dataserver.models.config import Config
from dataserver.models.dataframe import ParsedPagesDataFrame, SignalDataFrame, LastSessionDataFrame
from dataserver.service import BookService
from dataserver.service.nlp import NLPService

import time
import json

from dataserver.service.user import UserService


def preprocess_paginate_logs(df, nlp_service: NLPService, book_service: BookService, config: Config):
    rdf = parse_review_paginate_logs(df, nlp_service)
    odf = parse_ordinary_paginate_logs(df, nlp_service, book_service)
    df = pd.concat([rdf, odf], axis=0)

    df = parse_paginate_logs(df)
    df = merge_pages_df(df, config.cluster_threshold)

    def _calculate_wpm(x):
        return len(x['words']) / x['eltime'] * 60

    df['wpm'] = df.apply(_calculate_wpm, axis=1)
    df = df.loc[df['wpm'] < config.filter_wpm_threshold]

    df = annotate_pages_df(df, config.max_session_hours, config.cheat_eltime_threshold)
    return df

def parse_review_paginate_logs(logs_df, nlp_service: NLPService):
    logs_df = logs_df.loc[logs_df['type'] == 'review-paginate']
    if len(logs_df) == 0:
        return pd.DataFrame(columns=['time', 'from', 'rcId', 'userId', 'eltime', 'text'])

    def _parse_payload(df):
        df['payload'] = df['payload'].map(json.loads)
        df['eltime'] = df['payload'].map(lambda x: x['time'])
        df['content'] = df['payload'].map(lambda x: x['content'])
        df['rcId'] = df['payload'].map(lambda x: x['reviewId'])
        return df
    pages_df = _parse_payload(logs_df)

    def _get_text(row):
        sids = row['payload']['sids']
        word_unknowns = row['payload']['wordUnknowns']

        return [parse_word_unknowns(nlp_service, sids, row['content'], word_unknowns)]

    pages_df['text'] = pages_df.apply(_get_text, axis=1).map(lambda x: x[0])
    pages_df['from'] = 'review'
    return pages_df[['time', 'from', 'rcId', 'userId', 'eltime', 'text']]

def parse_ordinary_paginate_logs(logs_df, nlp_service: NLPService, book_service: BookService):
    logs_df = logs_df.loc[logs_df['type'] == 'paginate']
    if len(logs_df) == 0:
        return pd.DataFrame(columns=['time', 'from', 'rcId', 'userId', 'eltime', 'text'])

    import json
    def _flatten_payload(df):
        df['payload'] = df['payload'].map(json.loads)
        df['eltime'] = df['payload'].map(lambda x: x['time'])
        df['rcId'] = df['payload'].map(lambda x: x['bookId'])
        df = df.loc[df['rcId'].isin(book_service.get_book_ids())]
        return df

    pages_df = _flatten_payload(logs_df)

    def _get_text(row):
        book_id = row['rcId']
        sids = row['payload']['sids']
        word_unknowns = row['payload']['wordUnknowns']
        book = book_service.get_book(book_id)
        if book is None:
            return []
        sentences = [book.get_sentence(sid) or "" for sid in sids]

        return [parse_word_unknowns(nlp_service, sids, sentences, word_unknowns)]

    pages_df['text'] = pages_df.apply(_get_text, axis=1).map(lambda x: x[0])
    pages_df['from'] = 'reader'
    return pages_df[['time', 'from', 'rcId', 'userId', 'eltime', 'text']]

def parse_paginate_logs(pages_df):
    def _flatten_text(df):
        df['words'] = df['text'].map(lambda x: x['words'])
        df['pos'] = df['text'].map(lambda x: x['pos'])
        df['unknownIndices'] = df['text'].map(lambda x: x['unknownIndices'])
        df['unknownWords'] = df['text'].map(lambda x: x['unknownWords'])
        df['unknownIndices'] = df['text'].map(lambda x: x['unknownIndices'])
        df['sids'] = df['text'].map(lambda x: x['sids'])
        return df

    pages_df = _flatten_text(pages_df)

    from .utils import parse_ts_from_iso
    pages_df['time'] = pages_df['time'].map(lambda x: parse_ts_from_iso(x))
    pages_df['eltime'] /= 1000.0

    pages_df = pages_df[
        ['time', 'userId', 'from', 'rcId', 'eltime', 'sids', 'pos', 'words', 'unknownWords', 'unknownIndices']]

    return ParsedPagesDataFrame.validate(pages_df)


def parse_word_unknowns(nlp_service: NLPService, sids, sentences, word_unknowns):
    words = []
    unknown_indices = []
    unknown_words = []
    poss = []
    i = 0
    for sentence, sid in zip(sentences, sids):
        tmp = split_sentence(sentence)
        pos = [x[1] for x in nlp_service.pos_tag(tmp)]
        poss.extend(pos)
        words.extend([str(word).lower() for word in tmp])
        for wu in word_unknowns:
            if wu['sentenceId'] == sid:
                wi = wu['wordIndex']
                if tmp[wi] != wu['word']:
                    raise Exception(sentence + ' ' + sid + ' word mismatch: ' + tmp[wi] + ',' + wu['word'])
                unknown_indices.append(wi + i)
                unknown_words.append(str(tmp[wi]).lower())
        i += len(tmp)
    return {'words': words, 'pos': poss, 'unknownIndices': unknown_indices, 'unknownWords': unknown_words,
            'sids': sids}


def merge_pages_df(df, cluster_threshold: float):
    pages_df = df.loc[df['eltime'] != 0]
    pages_df = pages_df.sort_values(['time'])

    def _assign_page_id(df):
        df['words2'] = df['words'].map(lambda x: ' '.join(x))
        words2_df = pd.DataFrame(df['words2'].unique(), columns=['words2'])
        words2_df = words2_df.reset_index()
        words2_df = words2_df.rename(columns={'index': 'id'})
        return words2_df.set_index('words2').join(df.set_index('words2'))

    pages_df = _assign_page_id(pages_df).reset_index(drop=True)

    def merge(rows):
        out = []
        last_time = 0

        for i in range(len(rows['time'])):
            time = rows['time'].iloc[i]
            eltime = rows['eltime'].iloc[i]
            words = rows['words'].iloc[i]
            uis = rows['unknownIndices'].iloc[i]
            uwords = rows['unknownWords'].iloc[i]
            fromCol = rows['from'].iloc[i]
            rcId = rows['rcId'].iloc[i]
            sids = rows['sids'].iloc[i]
            pos = rows['pos'].iloc[i]

            if last_time != 0 and time - last_time > cluster_threshold * 60:
                out.append(
                    {'time': time_, 'pos': pos_, 'eltime': eltime_, 'rcId': rcId_, 'unknownIndices': uis_,
                     'sids': sids_,
                     'unknownWords': uwords_, 'words': words_, 'from': fromCol_ })
                last_time = 0

            if last_time == 0:
                last_time = time
                time_ = time
                eltime_ = eltime
                words_ = words
                uis_ = uis
                sids_ = sids
                pos_ = pos
                uwords_ = uwords
                rcId_ = rcId
                fromCol_ = fromCol
            else:
                uwords_.extend(uwords)
                uis_.extend(uis)
                eltime_ += eltime

        if last_time != 0:
            out.append({'time': time_, 'pos': pos_, 'eltime': eltime_, 'rcId': rcId_, 'from': fromCol_, 'unknownIndices': uis_,
                        'unknownWords': uwords_, 'words': words_, 'sids': sids_})
        return pd.DataFrame(out).reset_index(drop=True)

    pages_df = pages_df \
        .sort_values(['time']) \
        .groupby(['userId', 'id']) \
        .apply(merge) \
        .reset_index()
    del pages_df['level_2']
    del pages_df['id']

    return pages_df


def annotate_pages_df(df, max_session_hours: float, cheat_eltime_threshold: float):
    pages_df = df.copy()
    pages_df = pages_df.sort_values('time')

    def _extract_session(time):
        i = 0
        last = 0
        out = []
        for x in time:
            if last == 0:
                last = x
            if x - last > max_session_hours * 60 * 60:
                i += 1
                last = x
            out.append(i)
        return out

    pages_df['session'] = pages_df['time'].groupby(pages_df['userId']).transform(_extract_session)

    def _assign_cheat(df):
        eltimes = df.copy()
        eltimes['count'] = 1
        eltimes = eltimes.groupby('userId').sum()
        eltimes = eltimes[['eltime', 'count']]
        eltimes['cheat'] = eltimes['eltime'].map(lambda x: x <= cheat_eltime_threshold * 60)
        return df.set_index('userId').join(eltimes[['cheat']]).reset_index()

    pages_df = _assign_cheat(pages_df)

    pages_df['pageId'] = np.arange(len(pages_df))
    return pages_df


def extract_signals_df(pages_df):
    def _to_word(x):
        words = []
        for i in range(len(x['words'])):
            word = x['words'][i]
            words.append(word)
        return words

    def _to_signal(x):
        signals = []
        unknown_words = [y.lower() for y in x['unknownWords']]
        for i in range(len(x['words'])):
            word = x['words'][i].lower()
            signal = 0.0 if word in unknown_words else 1.0
            signals.append(signal)
        return signals

    def _to_pos(x):
        poss = []
        for i in range(len(x['pos'])):
            pos = x['pos'][i]
            poss.append(pos)
        return poss

    pages_df['word'] = pages_df.apply(_to_word, axis=1)
    pages_df['signal'] = pages_df.apply(_to_signal, axis=1)
    pages_df['pos'] = pages_df.apply(_to_pos, axis=1)
    pages_df = unnesting(
        pages_df[['userId', 'cheat', 'session', 'wpm', 'pos', 'time', 'pageId', 'word', 'signal']],
        ['word', 'pos', 'signal'])
    pages_df = pages_df.loc[~pd.isna(pages_df['pos'])]
    pages_df = pages_df.reset_index(drop=True)

    return SignalDataFrame.validate(pages_df)


def clean_signals_df(signals_df, nlp_service: NLPService):
    df = signals_df
    df = df.loc[(df['signal'] == 0).groupby([df['userId'], df['word']]).transform('any')]
    words = nlp_service.get_stop_words()
    clean_signals_df = df.loc[~df['word'].isin(words)]

    return SignalDataFrame.validate(clean_signals_df)


def clean_pages_df(pages_df, book_service: BookService):
    import json
    def _get_items_json(sids):
        out = []
        for sid in sids:
            item = book_service.get_item(sid)
            if item is not None:
                out.append(item.to_dict())
        return json.dumps(out)

    pages_df['itemsJson'] = pages_df['sids'].map(_get_items_json)

    def _clean_words(words):
        return pd.Series(words) \
            .map(lambda x: x.lower()) \
            .unique()

    pages_df['words'] = pages_df['words'].map(_clean_words)
    pages_df['unknownWords'] = pages_df['unknownWords'].map(_clean_words)
    del pages_df['pos']

    def _extract_known_words(words, unknown_words):
        unknown_words = pd.Series(unknown_words)
        words = pd.Series(words)
        return words[~words.isin(unknown_words)].tolist()

    pages_df['knownWords'] = pages_df.apply(lambda x: _extract_known_words(x['words'], x['unknownWords']), axis=1)
    del pages_df['unknownIndices']
    del pages_df['sids']

    return pages_df
