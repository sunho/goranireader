import hug
import datetime
from cachetools import cached, LRUCache, TTLCache
from gorani.shared import DataDB
from gorani.jobs.compute_similar_word import get_node, get_suf_tok_word_arr

MIN_SCORE = 3
MAX_LEN = 15

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
    wobj = word_to_obj[str(word)]
    ws = data_db.get_user_known_words(user_id)
    words = [word_to_obj[w] for w in ws if w in word_to_obj]
    ns = get_node(suf_tok_word_arr, wobj, MIN_SCORE)
    ns.sort(key=lambda n: n['score'], reverse=True)
    if len(ns) > MAX_LEN:
        ns = ns[:MAX_LEN]
    return [{'word': n['other_word'], 'score': n['score']} for n in ns]


