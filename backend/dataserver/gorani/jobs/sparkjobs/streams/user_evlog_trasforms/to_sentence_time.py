from gorani.shared import PartialStreamJob, StreamJobContext
from gorani.shared.schema import FlipPagePayloadSchema
from pyspark.sql import DataFrame
from pyspark.sql.functions import explode, monotonically_increasing_id, udf, from_json
from pyspark.sql.types import *
from typing import Optional
from gorani.shared.utils import uuid
from nltk import word_tokenize, pos_tag
from nltk.corpus import stopwords
import traceback
import pickle
import codecs

stop_words = set(stopwords.words('english'))

# TODO
def sentences_to_uwords(sentences):
    uwords = []
    for i in range(len(sentences)):
        current_index = 0
        for sentence in sentences[:i]:
            current_index += len(sentence.sentence) + 1
        for uword in sentences[i].uwords:
            uwords.append(uword.index + current_index)
    return uwords

def spans(toks, sentence):
    offset = 0
    for tok in toks:
        offset = sentence.find(tok[0], offset)
        yield tok[0], tok[1], offset, offset+len(tok[0])
        offset += len(tok[0])

def _convert_sentence(sentence):
    toks = word_tokenize(sentence.sentence)
    pos_toks = pos_tag(toks)
    span_toks = spans(pos_toks, sentence.sentence)
    out = []
    for tok in span_toks:
        isuword = False
        for uword in sentence.uwords:
            if tok[2] <= uword['index'] and uword['index'] <= tok[3]:
                isuword = True
                break

        item = (tok[0], tok[1], tok in stop_words, isuword)
        out.append(item)
    return out

def _convert_sentences(sentences):
    return pickle.dumps([_convert_sentence(s) for s in sentences])

convert_sentences = udf(_convert_sentences, BinaryType())

class TransformToSentenceTime(PartialStreamJob):
    def __init__(self, context: StreamJobContext):
        PartialStreamJob.__init__(self, context)

    def partial(self, df: DataFrame) -> Optional[DataFrame]:
        paragraph_df = df.where('kind = "flip_page"')\
            .withColumn('payload', from_json('payload', FlipPagePayloadSchema))\
            .withColumn('id', uuid())\
            .select('id', 'user_id', 'time', 'payload.interval', convert_sentences('payload.sentences').alias('paragraph'))\

        self.write_data_stream('user_flipped_paragraphs', paragraph_df)\
            .start()

        return None
