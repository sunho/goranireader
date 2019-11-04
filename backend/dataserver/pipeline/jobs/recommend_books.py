import matplotlib
matplotlib.use('Agg')

from gcloud import storage
import uuid
import reportng
import seaborn

from pyspark.sql import SparkSession
spark = SparkSession.builder.appName('Create Mission Report').getOrCreate()
sc = spark.sparkContext

from gorani import firebase
firebase.init('spark')
mydb = firebase.db()
from gorani.gorani import Gorani
from gorani.transformer import Transformer
from gorani.utils import split_sentence
gorani = Gorani(mydb)
transformer = Transformer(gorani, spark, sc)

from pyspark.sql.functions import col
from pyspark.sql.functions import udf
from gorani.transformer import piper
import pyspark.sql.functions as F
from pyspark.sql.types import *

c = -50
@F.udf(IntegerType())
def readingScore(ac, wpm):
    if ac > 0.9 and wpm > 250 + c:
        return 12
    elif ac > 0.85 and wpm > 237 + c:
        return 11
    elif ac > 0.825 and wpm > 224 + c:
        return 10
    elif ac > 0.8 and wpm > 214 + c: 
        return 9
    elif ac > 0.7 and wpm > 204 + c:
        return 8
    elif ac > 0.6 and wpm > 195 + c:
        return 7
    elif ac > 0.55 and wpm > 185 + c:
        return 6
    elif ac > 0.5 and wpm > 173 + c:
        return 5
    elif ac > 0.475 and wpm > 158 + c:
        return 4
    elif ac > 0.45 and wpm > 138 + c:
        return 3
    elif ac > 0.3 and wpm > 115 + c:
        return 2
    else:
        return 1

@F.udf(IntegerType())
def vocabScore(uv):
    v = (1 - uv)*100
    if v >= 99:
        return 12
    elif v >= 96:
        return 11
    elif v > 93:
        return 10
    elif v > 90: 
        return 9
    elif v > 87:
        return 8
    elif v > 84:
        return 7
    elif v > 81:
        return 6
    elif v > 78:
        return 5
    elif v > 75:
        return 4
    elif v > 72:
        return 3
    elif v > 69:
        return 2
    else:
        return 1

@F.udf(StringType())
def ymw(ts):
    from datetime import datetime
    dt = datetime.fromtimestamp(ts)
    return dt.strftime('%Y-%m-%d')

df = spark.read.json("gs://gorani-reader-249509-gorani-reader-event-log")

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
import pandas as pd
import math

qDf = df.filter(df['type'] == 'submit_question')\
    .withColumn('payload', from_json(col('payload'), SubmitQuestionPayload))\
    .withColumn('eltime', col('payload.time'))\
    .withColumn('qid', col('payload.questionId'))\
    .withColumn('chapterId', col('payload.chapterId'))\
    .withColumn('bookId', col('payload.bookId'))\
    .withColumn('option', col('payload.option'))\
    .withColumn('right', col('payload.right'))\
    .drop('payload')

rawDf = qDf.orderBy('time').dropDuplicates(['qid','userId','chapterId']).drop('time')\
    .withColumn('cr', F.when(col('right') == True, 1).otherwise(0)).groupBy('userId', 'bookId', 'chapterId')\
    .agg(F.sum(col('cr')).alias('score'), F.sum(col('eltime')).alias('time')).drop('cr')\
    .withColumn('total', transformer.get_questions_len(col('bookId'), col('chapterId')))\
    .withColumn('raw', col('score') / col('total'))

@pandas_udf(StructType(rawDf.schema.fields + [StructField('timeZ', FloatType()), StructField('scorePerc', FloatType())]), PandasUDFType.GROUPED_MAP)
def perc(df):
    sz = df['raw'].size-1
    df['scorePerc'] = df['raw'].rank(method='max').apply(lambda x: -1 if sz == 0 else (x-1)/sz)
    sd = df['time'].std()
    if sd == 0 or sd is None or math.isnan(sd):
        sd = 1
    df['timeZ'] = -(df['time'] - df['time'].mean())/sd
    return df

percDf = rawDf\
    .groupBy('chapterId').apply(perc)\
    .select('userId', 'timeZ', 'scorePerc', 'chapterId', 'bookId')

resDf = percDf.join(paginateDf, ['userId','chapterId','bookId'], 'inner')

df = resDf.filter(resDf['scorePerc'] >= 0)

indDf = df.n(transformer.parse_time())\
    .withColumn("id", F.monotonically_increasing_id())\
    .withColumn('sentence', F.explode('sentences'))\
    .withColumn('sid', F.col('sentence.sid'))\
    .withColumn('unknown', F.when(F.col('sentence.unknown') == True, 1).otherwise(0))\
    .withColumn('wordCount', F.size('sentence.words'))\
    .withColumn('uwordCount', F.size('sentence.unknownWords'))

senDf = indDf\
    .groupBy('id', 'userId', 'eltime', 'sentences', 'scorePerc', 'timeZ', 'classId', 'chapterId', 'bookId').agg(F.sum('unknown').alias('usenCount'), 
                       F.sum('wordCount').alias('wordCount'), 
                       F.sum('uwordCount').alias('uwordCount'))\
    .drop('id').withColumn('wpm', F.col('wordCount')/(F.col('eltime')/(1000*60))).filter(F.col('wpm') < 1000)\
    .filter(F.col('eltime') < 5*60*1000)

@F.pandas_udf(IntegerType())
def uscore(x,y):
    import pandas as pd
    return pd.Series([1 if y in x else 0 for x, y in zip(x,y)])


from pyspark.sql.window import Window
import time

vocabDf = indDf\
    .withColumn('sid', F.col('sentence.sid'))\
    .withColumn('wordCount', F.size('sentence.words'))\
    .withColumn('word', F.explode('sentence.words'))\
    .withColumn('no', uscore('sentence.unknownWords', F.col('word')))\
    .withColumn('yes', 1 - F.col('no'))\
    .withColumn('word', F.lower(F.col('word')))\
    .withColumn('word', transformer.stem('word'))\
    .groupBy('classId', 'userId', 'word')\
    .agg(F.sum('no').alias('ucount'), F.sum('yes').alias('ncount'))\
    .select('classId', 'userId', 'word', 'ucount', 'ncount')\

nwordDf = vocabDf.filter((F.col('ncount')-5*F.col('ucount')) > 0).drop('ncount').drop('ucount')

uwordDf = vocabDf.filter((F.col('ncount')-5*F.col('ucount')) <= 0).drop('ncount').drop('ucount')

@F.pandas_udf(ArrayType(StringType()))
def split_setence_udf(sen):
    from gorani.utils import split_sentence
    import pandas as pd
    return pd.Series([split_sentence(sen) for sen in sen])

from pyspark.sql.window import Window

totalCountDf = transformer.booksDf.withColumn('sentence', transformer.get_sentence('bookId', 'chapterId', 'sid'))\
        .withColumn('sentence', split_setence_udf('sentence'))\
        .withColumn('word', F.explode('sentence'))\
        .drop('sentence')\
        .withColumn('word', F.lower(F.col('word')))\
        .withColumn('word', transformer.stem('word'))\
        .drop('chapterId').drop('sid')\
        .dropDuplicates(['bookId', 'word'])\
        .withColumn('totalCount', F.count('*').over(Window.partitionBy('bookId')))

npercDf = totalCountDf.join(nwordDf, ['word'], 'inner')\
        .groupBy('classId', 'userId', 'bookId', 'totalCount')\
        .agg(F.count('*').alias('count'))\
        .withColumn('nperc', F.col('count')/F.col('totalCount'))\
        .drop('totalCount').drop('count')

upercDf = totalCountDf.join(uwordDf, ['word'], 'inner')\
        .groupBy('classId', 'userId', 'bookId', 'totalCount')\
        .agg(F.count('*').alias('count'))\
        .withColumn('uperc', F.col('count')/F.col('totalCount'))\
        .drop('totalCount').drop('count')

percDf = npercDf.join(upercDf, ['classId', 'userId', 'bookId'], 'full')\
                .withColumn('uperc', F.when(F.col('uperc').isNull(), 0).otherwise(F.col('uperc')))\
                .withColumn('nperc', F.when(F.col('nperc').isNull(), 0).otherwise(F.col('nperc')))\
                .withColumn('eperc', 1 - F.col('uperc') - F.col('nperc'))

from pyspark.sql.window import Window
import time

window = Window.partitionBy('classId', 'bookId').orderBy(F.col('uperc').desc())

classPercDf = percDf.groupBy('classId', 'bookId')\
    .agg(F.avg('eperc').alias('eperc'), F.avg('nperc').alias('nperc'), F.avg('uperc').alias('uperc'))

classStruggleDf = percDf\
    .select('classId', 'bookId', 'userId', F.row_number().over(window).alias('rank'))\
    .filter(F.col('rank') <= 2)\
    .withColumn('username', transformer.get_username(F.col('userId')))\
    .groupBy('classId', 'bookId')\
    .agg(F.collect_list('username').alias('struggles'))

classDf = classPercDf.join(classStruggleDf, ['classId', 'bookId'], 'inner')

rows = classDf.collect()

classes = list(set([row['classId'] for row in rows]))
out = {
    classId: [
        {
            'bookId': row['bookId'],
            'eperc': row['eperc'],
            'nperc': row['nperc'],
            'uperc': row['uperc'],
            'struggles': row['struggles']
        }
        for row in rows if row['classId'] == classId
    ]
    for classId in classes
}

for classId, res in out.items():
    mydb.collection('dataResult').document(classId).set({'recommendedBooks': res})
