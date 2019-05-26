#
# Copyright © 2019 Sunho Kim. All rights reserved.
#

import hug
import datetime
from cachetools import cached, LRUCache, TTLCache
from gorani.datadb import DataDB
from uuid import uuid4
from typing import List

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

def get_suf_tok_word_arr(words):
    suf_tok_word_arr = list()
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
    return suf_tok_word_arr

def get_graph(suf_tok_word_arr, words):
    out = list()
    for word in words:
        if word.pron == '':
            continue
        out.extend(get_node(suf_tok_word_arr, word))
    return out

def get_node(suf_tok_word_arr, word, min_rate):
    out = list()
    toks = word.pron.split(' ')
    toks.reverse()
    min_score = int(len(toks) * min_rate)
    s = suf_tok_word_arr[0][toks[0]]
    for i in range(1, len(toks)):
        s2 = s.intersection(suf_tok_word_arr[i][toks[i]])
        if i >= min_score:
            for word2 in s - s2:
                out.append({
                    'id': str(uuid4()),
                    'word': word.word,
                    'other_word': word2,
                    'score': i
                })
        s = s2
        if len(s) == 0:
            break

    if len(s) != 0:
        if len(toks) >= min_score:
            for word2 in s:
                if word2 == word.word:
                    continue
                out.append({
                    'id': str(uuid4()),
                    'word': word.word,
                    'other_word': word2,
                    'score': len(toks)
                })
    return out

MIN_RATE = 0.6
MAX_LEN = 30
def init(_data_db: DataDB):
    global data_db
    global word_to_obj
    global suf_tok_word_arr
    data_db = _data_db
    words = data_db.get_all('words')
    word_to_obj = {str(word.word):word for word in words}
    words = data_db.get_all('words')
    suf_tok_word_arr = get_suf_tok_word_arr(words)

@hug.get('/similar', output=hug.output_format.json)
@cached(cache=TTLCache(maxsize=102400, ttl=600))
def get_similar_word(user_id: int, word: str):
    ns = set(data_db.get_user_known_words(user_id))
    wobj = word_to_obj[str(word)]
    sw = get_node(suf_tok_word_arr, wobj, MIN_RATE)
    sw.sort(key=lambda n: (n['score'], -len(n['other_word'])), reverse=True)
    sw = [s for s in sw if s['other_word'] in ns]
    if len(sw) > MAX_LEN:
        sw = sw[:MAX_LEN]
    return [{'word': s['other_word'], 'score': s['score']} for s in sw]


