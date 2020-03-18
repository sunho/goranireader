import sys
from google.cloud import storage
from pyspark.sql import SparkSession
spark = SparkSession.builder.appName('Clean Logs').getOrCreate()
sc = spark.sparkContext
sc.addPyFile('gorani.zip')
from gorani import firebase
firebase.init('spark')
mydb = firebase.db()
from gorani.gorani import Gorani
from gorani.schema import EventLog
from gorani.transformer import Transformer
from gorani.utils import split_sentence
gorani = Gorani(mydb)

transformer = Transformer(gorani, spark, sc)
spark.conf.set("spark.sql.execution.arrow.enabled", "true")
import os
print("Read Input Start")
df = spark.read.json("gs://gorani-reader-249509-gorani-reader-event-log", EventLog)
print("Read Input")
from pyspark.sql.functions import col, pandas_udf, PandasUDFType
from pyspark.sql.functions import udf, from_json
import pyspark.sql.functions as F
from pyspark.sql.types import *

PaginateSentence = StructType([
    StructField("sid", StringType()),
    StructField("words", ArrayType(StringType())),
    StructField("unknownIndice", ArrayType(IntegerType())),
    StructField("unknownWords", ArrayType(StringType())),
    StructField("unknown", BooleanType())
])

SubmitQuestionPayload = StructType([
    StructField("bookId", StringType()),
    StructField("chapterId", StringType()),
    StructField("questionId", StringType()),
    StructField("option", StringType()),
    StructField("right", BooleanType()),
    StructField("time", IntegerType())
])


@udf(ArrayType(PaginateSentence))
def get_sentences(bookId, chapterId, sids, wordUnknowns, sentenceUnknowns):
    out = []
    for sid in sids:
        wis = []
        wus = []
        unknown = False
        sentence = gorani.get_sentence(bookId, chapterId, sid) or ""
        words = split_sentence(sentence)
        for su in sentenceUnknowns:
            if su['sentenceId'] == sid:
                unknown = True
        for wu in wordUnknowns:
            if wu['sentenceId'] == sid:
                wi = wu['wordIndex']
                if words[wi] != wu['word']:
                    raise Exception(sentence + ' ' + sid + ' word mismatch: ' + words[wi]  + ',' + wu['word'])
                wis.append(wi)
                wus.append(words[wi])
        out.append({'sid': sid, 'words': words, 'unknownIndice': wis, 'unknownWords': wus,'unknown': unknown})
    return out

paginateDf = df.n(transformer.parse_paginate())\
    .n(transformer.filter_cheat())\
    .withColumn('sentences', get_sentences(col('bookId'), col('chapterId'), col('sids'), col('wordUnknowns'), col('sentenceUnknowns')))\
    .select('time', 'classId', 'userId', 'bookId', 'chapterId', 'sentences', 'eltime')

print("Starting Job")
import json
result = paginateDf.rdd.map(lambda row: row.asDict(recursive=True)).collect()
print("Ended Job")
client = storage.Client()
bucket = client.get_bucket('gorani-reader-airflow')
blob = bucket.blob('output/cleaned_logs.json')
with open('/tmp/cleaned_logs.json', 'w') as f:
    json.dump(result, f)
blob.upload_from_filename('/tmp/cleaned_logs.json')

print("Wrote")
