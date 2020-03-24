from gorani.utils import split_sentence
from metaflow import FlowSpec, step, Flow
import pandas as pd
import json
import typing
from gorani.booky import Book

class MergeFilterPaginate(FlowSpec):
    books: typing.Dict[str, Book]

    @step
    def start(self):
        run = Flow('ExpandPaginate').latest_successful_run
        print('using data from flow: %s' % run.id)
        self.pages = run.data.pages
        self.next(self.work)

    @step
    def work(self):
        pages_df = self.pages
        pages_df['words'] = pages_df['text'].map(lambda x: x['words'])
        pages_df['unknownIndices'] = pages_df['text'].map(lambda x: x['unknownIndices'])
        pages_df['unknownWords'] = pages_df['text'].map(lambda x: x['unknownWords'])
        pages_df['unknownIndices'] = pages_df['text'].map(lambda x: x['unknownIndices'])
        pages_df = pages_df.loc[pages_df['eltime'] != 0]
        from gorani.utils import parse_ts
        pages_df['time'] = pages_df['time'].map(lambda x: parse_ts(x))
        pages_df = pages_df.sort_values(['time'])
        pages_df['words2'] = pages_df['words'].map(lambda x: ' '.join(x))
        import pandas as pd
        words2_df = pd.DataFrame(pages_df['words2'].unique(), columns=['words2'])
        words2_df = words2_df.reset_index()
        words2_df = words2_df.rename(columns={'index': 'id'})
        df = words2_df.join(pages_df.set_index('words2'), on='words2')
        def clsuter(rows):
            out = []
            tmp = 0
        
            for i in range(len(rows['time'])):
                time = rows['time'].iloc[i]
                eltime = rows['eltime'].iloc[i]
                words = rows['words'].iloc[i]
                uis = rows['unknownIndices'].iloc[i]
                uwords = rows['unknownWords'].iloc[i]
                bookId = rows['bookId'].iloc[i]
                if tmp == 0:
                    tmp = time
                    time_ = time
                    eltime_ = eltime
                    words_ = words
                    uis_ = uis
                    uwords_ = uwords
                    bookId_ = bookId
                else:
                    uwords_.extend(uwords)
                    uis_.extend(uis)
                    eltime_ += eltime
                
                if time - tmp >= 6.3*60:
                    out.append({'time': time_, 'eltime': eltime_, 'bookId': bookId_, 'unknownIndices': uis_, 'unknownWords': uwords_, 'words': words_, })
                    tmp = 0
            if tmp != 0 :
                out.append({'time': time_, 'eltime': eltime_, 'bookId': bookId_, 'unknownIndices': uis_, 'unknownWords': uwords_, 'words': words_, })
            return pd.DataFrame(out).reset_index(drop=True)

        df = df.sort_values(['time']).groupby(['userId', 'id']).apply(clsuter)
        df = df.reset_index()
        del df['level_2']
        del df['id']
        df['eltime'] /= 1000
        df['wpm'] = df.apply(lambda x: len(x['words']) / x['eltime'] * 60, axis=1)
        df = df.loc[df['wpm'] < 1000]
        self.pages = df
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
    MergeFilterPaginate()