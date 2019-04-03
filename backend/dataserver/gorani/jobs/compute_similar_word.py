from gorani.shared import Job, JobContext
from uuid import uuid4

import nltk
from functools import lru_cache
from itertools import product as iterprod

try:
    arpabet = nltk.corpus.cmudict.dict()
except LookupError:
    nltk.download('cmudict')
    arpabet = nltk.corpus.cmudict.dict()

@lru_cache()
def wordbreak(s):
    s = s.lower()
    if s in arpabet:
        return arpabet[s]
    middle = len(s)/2
    partition = sorted(list(range(len(s))), key=lambda x: (x-middle)**2-x)
    for i in partition:
        pre, suf = (s[:i], s[i:])
        if pre in arpabet and wordbreak(suf) is not None:
            return [x+y for x,y in iterprod(arpabet[pre], wordbreak(suf))]
    return None

def get_phones(s):
    phones = wordbreak(s)
    if phones is None:
        return None
    return phones[0]

class ComputeSimilarWord(Job):
    def __init__(self, context: JobContext):
        Job.__init__(self, context)

    def compute_one(self, user_id: int, word: str):
        rows = self.context.data_db.get_all('words').current_rows
        words = [row.word for row in rows]


    def compute_all(self, user_id: int, min_score: int):
        words = self.context.data_db.get_all('words')
        suf_tok_word_arr = list()
        out = list()
        for word in words:
            if word.pron == '':
                continue
            toks = word.pron.split(' ')
            toks.reverse()
            for i in range(len(toks)):
                if toks[i] == '':
                    continue
                if len(suf_tok_word_arr) == i:
                    item = dict()
                    item[toks[i]] = {word.word}
                    suf_tok_word_arr.append(item)
                else:
                    if toks[i] not in suf_tok_word_arr[i]:
                        suf_tok_word_arr[i][toks[i]] = {word.word}
                    else:
                        suf_tok_word_arr[i][toks[i]].add(word.word)

        words = self.context.data_db.get_all('words')
        c = 0
        for word in words:
            c += 1
            print(c)
            if word.pron == '':
                continue
            toks = word.pron.split(' ')
            toks.reverse()
            s = suf_tok_word_arr[0][toks[0]]
            score = 1
            for i in range(1, len(toks)):
                s = s - suf_tok_word_arr[i][toks[i]]
                score += 1
                if score >= min_score:
                    for word2 in s:
                        out.append({
                            'id': str(uuid4()),
                            'word': word.word,
                            'other_word': word2,
                            'score': score
                        })
                if len(s) == 0:
                    break

            if len(s) != 0:
                if score >= min_score:
                    for word2 in s:
                        out.append({
                            'id': str(uuid4()),
                            'word': word.word,
                            'other_word': word2,
                            'score': score
                        })

        return out
