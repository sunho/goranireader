from gorani.spark import write_data_stream
from gorani.schema import FlipPagePayloadSchema
from gorani.utils import pickle_dump
from pyspark.sql import DataFrame
from pyspark.sql.functions import explode, monotonically_increasing_id, udf, from_json
from pyspark.sql.types import *
from typing import Optional
from gorani.utils import uuid
from nltk import word_tokenize, pos_tag
from nltk.corpus import stopwords
import traceback
import pickle
import codecs


stop_words = set(stopwords.words('english'))

def _sentences_to_uwords(sentences):
    uwords = []
    for i in range(len(sentences)):
        current_index = 0
        for sentence in sentences[:i]:
            current_index += len(sentence.sentence) + 1
        for uword in sentences[i].uwords:
            uwords.append(uword['index'] + current_index)
    return uwords

def spans(toks, sentence):
    offset = 0
    for tok in toks:
        offset = sentence.find(tok[0], offset)
        yield tok[0], tok[1], offset, offset+len(tok[0])
        offset += len(tok[0])

def _convert_sentences(sentences):
    text = ' '.join([s.sentence for s in sentences])
    uwords = _sentences_to_uwords(sentences)
    toks = word_tokenize(text)
    pos_toks = pos_tag(toks)
    span_toks = spans(pos_toks, text)
    out = []
    for tok in span_toks:
        isuword = False
        for uword in uwords:
            if tok[2] <= uword and uword <= tok[3]:
                isuword = True
                break

        item = {
            'word': tok[0].lower(),
            'pos': tok[1],
            'stop': tok in stop_words,
            'uword': isuword
        }
        out.append(item)
    return out

convert_sentences = udf(_convert_sentences, ArrayType(
    StructType(
        [
            StructField('word', StringType()),
            StructField('pos', StringType()),
            StructField('stop', BooleanType()),
            StructField('uword', BooleanType())
        ]
    )
))

def start(df):
    paragraph_df = df.where('kind = "flip_page"')\
        .withColumn('payload', from_json('payload', FlipPagePayloadSchema))\
        .withColumn('id', uuid())\
        .select('id', 'user_id', 'time', 'payload.interval', convert_sentences('payload.sentences').alias('paragraph'))

    write_data_stream('user_flipped_paragraphs', paragraph_df.withColumn('paragraph', pickle_dump('paragraph')))\
        .start()

    return paragraph_df


