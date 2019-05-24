#
# Copyright © 2019 Sunho Kim. All rights reserved.
#

import hug
import datetime
from cachetools import cached, LRUCache, TTLCache
from gorani.shared import DataDB
from gorani.jobs.compute_similar_word import get_node, get_suf_tok_word_arr

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


