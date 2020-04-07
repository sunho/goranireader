from gorani.utils import split_sentence, unnesting
from metaflow import FlowSpec, step, Flow, IncludeFile, conda_base, batch
import pandas as pd
import json
import typing
import numpy as np
from gorani.booky import Book
from send import log_msg
import pandera as pa
from nltk import pos_tag

ExpandPagesOutput = pages_df=pa.DataFrameSchema({
    "time": pa.Column(pa.String),
    "userId": pa.Column(pa.String),
    "eltime": pa.Column(pa.Int),
    "bookId": pa.Column(pa.String),
    "text": pa.Column(pa.Object),
}, strict=True)

MergeFilterPagesOutput = pa.DataFrameSchema({
    "time": pa.Column(pa.Int),
    "userId": pa.Column(pa.String),
    "eltime": pa.Column(pa.Float),
    "wpm": pa.Column(pa.Float),
    "bookId": pa.Column(pa.String),
    "sids": pa.Column(pa.Object),
    "pos": pa.Column(pa.Object),
    "words": pa.Column(pa.Object),
    "unknownWords": pa.Column(pa.Object),
    "unknownIndices": pa.Column(pa.Object)
}, strict=True)

PagesDataFrame = pa.DataFrameSchema({
    "i": pa.Column(pa.Int),
    "time": pa.Column(pa.Int),
    "userId": pa.Column(pa.String),
    "eltime": pa.Column(pa.Float),
    "wpm": pa.Column(pa.Float),
    "bookId": pa.Column(pa.String),
    "sids": pa.Column(pa.Object),
    "words": pa.Column(pa.Object),
    "pos": pa.Column(pa.Object),
    "unknownWords": pa.Column(pa.Object),
    "unknownIndices": pa.Column(pa.Object),
    "session": pa.Column(pa.Int),
    "cheat": pa.Column(pa.Bool),
}, strict=True)

SignalDataFrame = pa.DataFrameSchema({
    "i": pa.Column(pa.Int),
    "word": pa.Column(pa.String),
    "signal": pa.Column(pa.Float),
    "userId": pa.Column(pa.String),
    "session": pa.Column(pa.Int),
    "cheat": pa.Column(pa.Bool),
    "pos": pa.Column(pa.String),
    "time": pa.Column(pa.Int),
    "eltime": pa.Column(pa.Float),
    "wpm": pa.Column(pa.Float)
}, strict=True)

CleanPagesDataFrame = pa.DataFrameSchema({
    "i": pa.Column(pa.Int),
    "time": pa.Column(pa.Int),
    "userId": pa.Column(pa.String),
    "eltime": pa.Column(pa.Float),
    "wpm": pa.Column(pa.Float),
    "bookId": pa.Column(pa.String),
    "itemsJson": pa.Column(pa.String),
    "words": pa.Column(pa.Object),
    "knownWords": pa.Column(pa.Object),
    "unknownWords": pa.Column(pa.Object),
    "session": pa.Column(pa.Int),
    "cheat": pa.Column(pa.Bool),
}, strict=True)

SessionInfoDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "session": pa.Column(pa.Int),
    "start": pa.Column(pa.Int),
    "end": pa.Column(pa.Int),
    "wpm": pa.Column(pa.Float),
    "readWords": pa.Column(pa.Int),
    "unknownWords": pa.Column(pa.Int),
    "hours": pa.Column(pa.Float),
}, strict=True)

@conda_base(libraries= {
    'boto3': '1.12',
    'gorani': '1.0.5',
    'pandera': '0.3.2',
    'rsa': '4.0'
})
class PreprocessPaginate(FlowSpec):
    @step
    def start(self):
        flow = Flow('DownloadLog').latest_successful_run
        print('using data from flow: %s' % flow.id)
        self.books = flow.data.books
        self.logs = flow.data.logs

        self.filter_wpm_threshold = 1000
        self.cluster_threshold = 6.5
        self.max_session_hours = 12
        self.cheat_eltime_threshold = 665

        self.next(self.expand_pages_df)

    @step
    def expand_pages_df(self):
        logs_df = pd.DataFrame(self.logs)
        schema = pa.DataFrameSchema({
            "userId": pa.Column(pa.String),
            "time": pa.Column(pa.String),
            "type": pa.Column(pa.String),
            "serverTime": pa.Column(pa.String),
        })
        logs_df = schema.validate(logs_df)

        pages_df = logs_df.loc[logs_df['type'] == 'paginate']

        def flatten_payload(df):
            df['payload'] = df['payload'].map(json.loads)
            df['eltime'] = df['payload'].map(lambda x: x['time'])
            df['bookId'] = df['payload'].map(lambda x: x['bookId'])
            df = df.loc[df['bookId'].isin(self.books.keys())]
            return df
        pages_df = flatten_payload(pages_df)

        # get text
        pages_df['text'] = pages_df.apply(self.get_text, axis=1).map(lambda x: x[0])
        pages_df = pages_df[['time', 'userId', 'eltime', 'bookId', 'text']]

        self.pages_df = ExpandPagesOutput.validate(pages_df)
        self.next(self.merge_filter_pages_df)

    def get_text(self, row):
        book_id = row['bookId']
        sids = row['payload']['sids']
        word_unknowns = row['payload']['wordUnknowns']

        words = []
        unknown_indices = []
        unknown_words = []
        poss = []
        for sid in sids:
            sentence = self.books[book_id].get_sentence(sid) or ""
            tmp = split_sentence(sentence)
            pos = [x[1] for x in pos_tag(tmp)]
            poss.extend(pos)
            words.extend(tmp)
            for wu in word_unknowns:
                if wu['sentenceId'] == sid:
                    wi = wu['wordIndex']
                    if tmp[wi] != wu['word']:
                        raise Exception(sentence + ' ' + sid + ' word mismatch: ' + tmp[wi] + ',' + wu['word'])
                    unknown_indices.append(wi)
                    unknown_words.append(tmp[wi])
        return [{'words': words, 'pos': poss, 'unknownIndices': unknown_indices, 'unknownWords': unknown_words, 'sids': sids}]

    @step
    def merge_filter_pages_df(self):
        pages_df = self.pages_df.copy()

        def flatten_text(df):
            df['words'] = df['text'].map(lambda x: x['words'])
            df['pos'] = df['text'].map(lambda x: x['pos'])
            df['unknownIndices'] = df['text'].map(lambda x: x['unknownIndices'])
            df['unknownWords'] = df['text'].map(lambda x: x['unknownWords'])
            df['unknownIndices'] = df['text'].map(lambda x: x['unknownIndices'])
            df['sids'] = df['text'].map(lambda x: x['sids'])
            return df
        pages_df = flatten_text(pages_df)

        # parse timestamp
        from gorani.utils import parse_ts
        pages_df['time'] = pages_df['time'].map(lambda x: parse_ts(x))
        pages_df = pages_df.loc[pages_df['eltime'] != 0]
        pages_df = pages_df.sort_values(['time'])

        def assign_page_id(df):
            df['words2'] = df['words'].map(lambda x: ' '.join(x))
            words2_df = pd.DataFrame(df['words2'].unique(), columns=['words2'])
            words2_df = words2_df.reset_index()
            words2_df = words2_df.rename(columns={'index': 'id'})
            return words2_df.join(df.set_index('words2'), on='words2')
        pages_df = assign_page_id(pages_df)

        cluster_threshold = self.cluster_threshold
        def merge(rows):
            out = []
            last_time = 0

            for i in range(len(rows['time'])):
                time = rows['time'].iloc[i]
                eltime = rows['eltime'].iloc[i]
                words = rows['words'].iloc[i]
                uis = rows['unknownIndices'].iloc[i]
                uwords = rows['unknownWords'].iloc[i]
                bookId = rows['bookId'].iloc[i]
                sids = rows['sids'].iloc[i]
                pos = rows['pos'].iloc[i]

                if last_time == 0:
                    last_time = time
                    time_ = time
                    eltime_ = eltime
                    words_ = words
                    uis_ = uis
                    sids_ = sids
                    pos_ = pos
                    uwords_ = uwords
                    bookId_ = bookId
                else:
                    uwords_.extend(uwords)
                    uis_.extend(uis)
                    eltime_ += eltime

                if time - last_time >= cluster_threshold * 60:
                    out.append(
                        {'time': time_, 'pos': pos_, 'eltime': eltime_, 'bookId': bookId_, 'unknownIndices': uis_, 'sids': sids_,
                         'unknownWords': uwords_, 'words': words_, })
                    last_time = 0
            if last_time != 0:
                out.append({'time': time_, 'pos': pos_, 'eltime': eltime_, 'bookId': bookId_, 'unknownIndices': uis_,
                            'unknownWords': uwords_, 'words': words_, 'sids': sids_})
            return pd.DataFrame(out).reset_index(drop=True)
        pages_df = pages_df\
            .sort_values(['time'])\
            .groupby(['userId', 'id'])\
            .apply(merge)\
            .reset_index()
        del pages_df['level_2']
        del pages_df['id']

        # filter fast forwards
        pages_df['eltime'] /= 1000.0
        pages_df['wpm'] = pages_df.apply(lambda x: len(x['words']) / x['eltime'] * 60, axis=1)
        pages_df = pages_df.loc[pages_df['wpm'] < self.filter_wpm_threshold]

        self.pages_df = MergeFilterPagesOutput.validate(pages_df)
        self.next(self.annoatate_pages_df)

    @step
    def annoatate_pages_df(self):
        pages_df = self.pages_df.sort_values('time').copy()

        max_session_hours = self.max_session_hours
        def extract_session(time):
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
        pages_df['session'] = pages_df['time'].groupby(pages_df['userId']).transform(extract_session)

        cheat_eltime_threshold = self.cheat_eltime_threshold
        def assign_cheat(df):
            eltimes = df.copy()
            eltimes['count'] = 1
            eltimes = eltimes.groupby('userId').sum()
            eltimes = eltimes[['eltime', 'count']]
            eltimes['cheat'] = eltimes['eltime'].map(lambda x: x <= cheat_eltime_threshold)
            return df.set_index('userId').join(eltimes[['cheat']]).reset_index()
        pages_df = assign_cheat(pages_df)

        pages_df['i'] = np.arange(len(pages_df))
        self.pages_df = PagesDataFrame.validate(pages_df)
        self.next(self.extract_signals_df)

    @step
    def extract_signals_df(self):
        pages_df = self.pages_df.copy()

        def to_word(x):
            words = []
            for i in range(len(x['words'])):
                word = x['words'][i]
                words.append(word)
            return words

        def to_signal(x):
            signals = []
            unknown_words = [y.lower() for y in x['unknownWords']]
            for i in range(len(x['words'])):
                word = x['words'][i].lower()
                signal = 0 if word in unknown_words else 1
                signals.append(signal)
            return signals

        def to_pos(x):
            poss = []
            for i in range(len(x['pos'])):
                pos = x['pos'][i]
                poss.append(pos)
            return poss
        pages_df['word'] = pages_df.apply(to_word, axis=1)
        pages_df['signal'] = pages_df.apply(to_signal, axis=1)
        pages_df['pos'] = pages_df.apply(to_pos, axis=1)
        pages_df = unnesting(pages_df[['userId', 'cheat', 'session', 'pos', 'time', 'eltime', 'wpm', 'i', 'word', 'signal']],
                       ['word', 'pos', 'signal'], axis=1)
        pages_df = pages_df.reset_index(drop=True)
        self.signals_df = SignalDataFrame.validate(pages_df)
        df = pages_df.copy()
        df = df.loc[(df['signal'] == 0).groupby([df['userId'], df['word']]).transform('any')]
        from nltk.corpus import stopwords
        words = list(stopwords.words('english'))
        clean_signals_df = df.loc[~df['word'].isin(words)]
        self.clean_signals_df = SignalDataFrame.validate(clean_signals_df)
        self.next(self.make_clean_pages_df)

    @step
    def make_clean_pages_df(self):
        pages_df = self.pages_df.copy()
        def get_items_json(sids):
            out = []
            for sid in sids:
                out.append(self.get_item(sid))
            return json.dumps(out)
        pages_df['itemsJson'] = pages_df['sids'].map(get_items_json)

        def clean_words(words):
            return pd.Series(words)\
                .map(lambda x: x.lower())\
                .unique()

        pages_df['words'] = pages_df['words'].map(clean_words)
        pages_df['unknownWords'] = pages_df['unknownWords'].map(clean_words)
        del pages_df['pos']
        def extract_known_words(words, unknown_words):
            unknown_words = pd.Series(unknown_words)
            words = pd.Series(words)
            return words[~words.isin(unknown_words)].tolist()
        pages_df['knownWords'] = pages_df.apply(lambda x: extract_known_words(x['words'], x['unknownWords']), axis=1)
        del pages_df['unknownIndices']
        del pages_df['sids']
        self.clean_pages_df = CleanPagesDataFrame.validate(pages_df)
        self.next(self.extract_session_info_df)

    def get_item(self, sid):
        for book in self.books.values():
            out = book.get_item(sid)
            if out is not None:
                return out.to_dict()
        return None

    @step
    def extract_session_info_df(self):
        signals_df = self.signals_df.copy()

        df = signals_df.groupby(['userId', 'session']) \
            .agg(start=('time', 'min'),
                 end=('time', 'max'),
                 nwords=('signal', 'sum'),
                 readWords=('word', 'count'))
        df['unknownWords'] = (df['readWords'] - df['nwords']).astype('int64')
        del df['nwords']

        clean_pages_df = self.clean_pages_df.copy()
        df2 = clean_pages_df.groupby(['userId', 'session']) \
            .agg(wpm=('wpm', 'mean'),
                 eltime=('eltime', 'sum'))
        df2['hours'] = (df2['eltime']) / (60 * 60)
        del df2['eltime']

        df3 = df.join(df2).reset_index()

        self.session_info_df = SessionInfoDataFrame.validate(df3)
        self.next(self.end)
    @step
    def end(self):
        log_msg('./preprocess_paginate.py', 'processed: %d' % self.signals_df.size, False)

if __name__ == '__main__':
    PreprocessPaginate()