from gorani.utils import split_sentence
from metaflow import FlowSpec, step, Flow
import pandas as pd
import json
import typing
from gorani.booky import Book

class ExpandPaginate(FlowSpec):
    books: typing.Dict[str, Book]

    @step
    def start(self):
        flow = Flow('DownlodLog').latest_successful_run
        print('using data from flow: %s' % flow.id)
        self.logs = flow.data.logs
        self.books = flow.data.books
        self.users = flow.data.users
        self.next(self.work)

    @step
    def work(self):
        logs_df = pd.DataFrame(self.logs)
        paginate_df = logs_df.loc[logs_df['type'] == 'paginate']
        paginate_df['payload'] = paginate_df['payload'].map(json.loads)
        paginate_df['eltime'] = paginate_df['payload'].map(lambda x: x['time'])
        paginate_df['bookId'] = paginate_df['payload'].map(lambda x: x['bookId'])
        paginate_df = paginate_df.loc[paginate_df['bookId'].isin(self.books.keys())]
        paginate_df['text'] = paginate_df.apply(self.get_text, axis=1).map(lambda x: x[0])
        self.pages = paginate_df[['time', 'userId', 'eltime', 'bookId', 'text']]
        self.next(self.end)

    def get_text(self, row):
        book_id = row['bookId']
        sids = row['payload']['sids']
        word_unknowns = row['payload']['wordUnknowns']

        words = []
        unknown_indices = []
        unknown_words = []
        for sid in sids:
            sentence = self.books[book_id].get_sentence(sid) or ""
            tmp = split_sentence(sentence)
            words.extend(split_sentence(sentence))
            for wu in word_unknowns:
                if wu['sentenceId'] == sid:
                    wi = wu['wordIndex']
                    if tmp[wi] != wu['word']:
                        raise Exception(sentence + ' ' + sid + ' word mismatch: ' + tmp[wi] + ',' + wu['word'])
                    unknown_indices.append(wi)
                    unknown_words.append(tmp[wi])
        return [{'words': words, 'unknownIndices': unknown_indices, 'unknownWords': unknown_words}]

    @step
    def end(self):
        print('processed: %d' % self.pages.size)

if __name__ == '__main__':
    ExpandPaginate()