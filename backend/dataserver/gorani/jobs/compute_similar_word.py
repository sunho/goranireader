from gorani.shared import Job, JobContext
from uuid import uuid4

class ComputeSimilarWord(Job):
    def __init__(self, context: JobContext):
        Job.__init__(self, context)

    def compute(self, min_score: int):
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
