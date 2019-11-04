import matplotlib
matplotlib.use('Agg')

from gcloud import storage
import uuid
import reportng
import seaborn

from pyspark.sql import SparkSession
spark = SparkSession.builder.appName('Calculater Performance').getOrCreate()
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
    .withColumn("ymw", ymw("ts"))\
    .withColumn('sentence', F.explode('sentences'))\
    .withColumn('sid', F.col('sentence.sid'))\
    .withColumn('unknown', F.when(F.col('sentence.unknown') == True, 1).otherwise(0))\
    .withColumn('wordCount', F.size('sentence.words'))\
    .withColumn('uwordCount', F.size('sentence.unknownWords'))

senDf = indDf\
    .groupBy('id', 'ymw', 'userId', 'eltime', 'sentences', 'scorePerc', 'timeZ', 'classId', 'chapterId', 'bookId').agg(F.sum('unknown').alias('usenCount'), 
                       F.sum('wordCount').alias('wordCount'), 
                       F.sum('uwordCount').alias('uwordCount'))\
    .drop('id').withColumn('wpm', F.col('wordCount')/(F.col('eltime')/(1000*60))).filter(F.col('wpm') < 1000)

@F.pandas_udf(IntegerType())
def uscore(x,y):
    import pandas as pd
    return pd.Series([1 if y in x else 0 for x, y in zip(x,y)])

from pyspark.sql.window import Window

window = Window.partitionBy('userId').orderBy(F.col('ymw')).rangeBetween(Window.unboundedPreceding, Window.currentRow)

userYmwDf = senDf\
    .groupBy('ymw','classId','userId')\
    .agg(F.count('*').alias('count'), F.sum('wpm').alias('wpm'), F.sum('scorePerc').alias('scorePerc'), F.sum('eltime').alias('time'))\
    .select('ymw', 'classId', 'userId', 'time',
            (F.sum('wpm').over(window) / F.sum('count').over(window)).alias('wpm'),
            (F.sum('scorePerc').over(window) / F.sum('count').over(window)).alias('scorePerc'))\
    .withColumn('rc', readingScore('scorePerc','wpm'))\
    .withColumn('username', transformer.get_username('userId'))

userBookDf = senDf.filter(F.col('eltime') < 5*60*1000)\
    .groupBy('classId','bookId','userId')\
    .agg(F.count('*').alias('count'), F.avg('wpm').alias('wpm'), F.avg('scorePerc').alias('scorePerc'), F.sum('uwordCount').alias('uwordCount'), F.sum('eltime').alias('time'), F.avg('timeZ').alias('timeZ'))\
    .withColumn('rc', readingScore('scorePerc','wpm'))\
    .withColumn('username', transformer.get_username('userId'))

userDf = senDf.filter(F.col('eltime') < 5*60*1000)\
    .groupBy('classId','userId')\
    .agg(F.count('*').alias('count'), F.avg('wpm').alias('wpm'), F.avg('scorePerc').alias('scorePerc'), F.sum('uwordCount').alias('uwordCount'), F.sum('eltime').alias('time'), F.avg('timeZ').alias('timeZ'))\
    .withColumn('rc', readingScore('scorePerc','wpm'))\
    .withColumn('username', transformer.get_username('userId'))

@piper
def calculate_uperc(df, args):
    return df.withColumn('sentence', F.explode('sentences'))\
    .withColumn('sid', F.col('sentence.sid'))\
    .withColumn('wordCount', F.size('sentence.words'))\
    .withColumn('word', F.explode('sentence.words'))\
    .withColumn('no', uscore('sentence.unknownWords', F.col('word')))\
    .withColumn('yes', 1 - F.col('no'))\
    .withColumn('word', F.lower(F.col('word')))\
    .dropDuplicates(args + ['userId', 'word', 'yes', 'no'])\
    .groupBy(*(['userId', 'word']+args))\
    .agg(F.sum('yes').alias('yes'), F.sum('no').alias('no'))\
    .withColumn('yes', F.when((F.col('yes') == 1) & (F.col('no') == 0), 1).otherwise(0))\
    .groupBy(*(['userId']+args))\
    .agg(F.sum('yes').alias('nwordCount'), F.sum('no').alias('uwordCount'))\
    .withColumn('uperc', F.col('uwordCount') / (F.col('uwordCount') + F.col('nwordCount')))\
    .select(*(['userId', 'uperc'] + args))\
    .withColumn('vc', vocabScore('uperc'))

window = Window.partitionBy('userId').orderBy(F.col('ymw')).rangeBetween(Window.unboundedPreceding, Window.currentRow)

@piper
def calculate_uperc_ymw(df):
    return df.withColumn('sentence', F.explode('sentences'))\
    .withColumn('sid', F.col('sentence.sid'))\
    .withColumn('wordCount', F.size('sentence.words'))\
    .withColumn('word', F.explode('sentence.words'))\
    .withColumn('no', uscore('sentence.unknownWords', F.col('word')))\
    .withColumn('yes', 1 - F.col('no'))\
    .withColumn('word', F.lower(F.col('word')))\
    .dropDuplicates(['userId', 'word', 'yes', 'no'])\
    .groupBy('userId', 'word', 'ymw')\
    .agg(F.sum('yes').alias('yes'), F.sum('no').alias('no'))\
    .withColumn('yes', F.when((F.col('yes') == 1) & (F.col('no') == 0), 1).otherwise(0))\
    .groupBy('userId', 'ymw')\
    .agg(F.sum('yes').alias('nwordCount'), F.sum('no').alias('uwordCount'))\
    .withColumn('uperc', F.sum('uwordCount').over(window) / (F.sum('uwordCount').over(window) + F.sum('nwordCount').over(window)))\
    .select('userId', 'uperc', 'ymw')\
    .withColumn('vc', vocabScore('uperc'))

ymwDf = senDf.n(calculate_uperc_ymw())\
    .join(userYmwDf, ['userId', 'ymw'], 'inner')\
    .orderBy('userId', 'ymw')

bookDf = senDf.n(calculate_uperc(['bookId']))\
    .join(userBookDf, ['userId', 'bookId'], 'inner')\
    .select('userId', 'bookId', 'wpm', 'rc', 'vc', 'uperc', 'scorePerc', 'count')

allDf = senDf.n(calculate_uperc([]))\
    .join(userDf, ['userId'], 'inner')\
    .withColumn('bookId', F.lit('all'))\
    .select('userId', 'bookId', 'wpm', 'rc', 'vc', 'uperc', 'scorePerc', 'count')

allBookDf = bookDf.union(allDf)

userIdToAge = {user.id: user.to_dict().get('age', -1) for user in mydb.collection('users').stream()}

@F.udf(IntegerType())
def age(user):
    return int(userIdToAge.get(user, 0))

from pyspark.sql.window import Window
import time

window = Window.partitionBy(F.col('userId')).orderBy(F.col('unknown').desc(), F.col('uwordCount').desc())

usenDf = indDf\
    .select('userId', 'bookId', 'chapterId', 'sid', 'unknown', 'uwordCount', F.row_number().over(window).alias('rank'))\
    .filter(~(F.col('unknown') == 0) | ~(F.col('uwordCount') == 0))\
    .filter(F.col('rank') <= 10)\
    .withColumn('sentence', transformer.get_sentence('bookId', 'chapterId', 'sid'))

from pyspark.sql.window import Window
import time

window = Window.partitionBy(F.col('userId')).orderBy(F.col('count').desc())

uwordDf = indDf\
    .withColumn('sid', F.col('sentence.sid'))\
    .withColumn('wordCount', F.size('sentence.words'))\
    .withColumn('word', F.explode('sentence.words'))\
    .withColumn('no', uscore('sentence.unknownWords', F.col('word')))\
    .withColumn('yes', 1 - F.col('no'))\
    .withColumn('word', F.lower(F.col('word')))\
    .groupBy('userId', 'word')\
    .agg(F.sum('no').alias('count'))\
    .select('userId', 'word', 'count', F.row_number().over(window).alias('rank'))\
    .filter(F.col('rank') <= 10)\
    .filter(~(F.col('count') == 0))

rows = uwordDf.collect()

users = list(set([row['userId'] for row in rows]))
out = {
    user: [
    {
        'word': row['word'],
        'count': row['count']
    }  for row in rows if row['userId'] == user]
    for user in users
}

userIdToClass = dict()
for userId, res in out.items():
    if userId not in userIdToClass:
        user = mydb.collection('users').document(userId).get().to_dict()
        userIdToClass[userId] = user['classId']
    ref = mydb.collection('dataResult').document(
        userIdToClass[userId]).collection('serverComputed').document(userId)
    try:
        doc = ref.get().to_dict()
        doc['unknownWords'] = res
        ref.set(doc)
    except:
        ref.set({
            'unknownWords': res
        })

rows = usenDf.collect()

users = list(set([row['userId'] for row in rows]))
out = {
    user: [
    {
        'sentence': row['sentence'],
        'uwordCount': row['uwordCount'],
        'unknown': row['unknown'],
        'bookId': row['bookId']
    }  for row in rows if row['userId'] == user]
    for user in users
}

userIdToClass = dict()
for userId, res in out.items():
    if userId not in userIdToClass:
        user = mydb.collection('users').document(userId).get().to_dict()
        userIdToClass[userId] = user['classId']
    ref = mydb.collection('dataResult').document(
        userIdToClass[userId]).collection('serverComputed').document(userId)
    try:
        doc = ref.get().to_dict()
        doc['unknownSentences'] = res
        ref.set(doc)
    except:
        ref.set({
            'unknownSentences': res
        })

rows = ymwDf.collect()

users = list(set([row['userId'] for row in rows]))
out = {
    user: {
        'vc': [{'x': row['ymw'], 'y': row['vc']} for row in rows if row['userId'] == user ],
        'rc': [{'x': row['ymw'], 'y': row['rc']} for row in rows if row['userId'] == user ],
        'score': [{'x': row['ymw'], 'y': row['scorePerc']} for row in rows if row['userId'] == user ],
        'wpm': [{'x': row['ymw'], 'y': row['wpm']} for row in rows if row['userId'] == user ],
        'uperc': [{'x': row['ymw'], 'y': row['uperc']} for row in rows if row['userId'] == user ]
    }
    for user in users
}

userIdToClass = dict()
for userId, res in out.items():
    if userId not in userIdToClass:
        user = mydb.collection('users').document(userId).get().to_dict()
        userIdToClass[userId] = user['classId']
    ref = mydb.collection('dataResult').document(
        userIdToClass[userId]).collection('serverComputed').document(userId)
    try:
        doc = ref.get().to_dict()
        doc['ymwPerformance'] = res
        ref.set(doc)
    except:
        ref.set({
            'ymwPerformance': res
        })


rows = senDf.groupBy('userId', 'ymw').agg(F.count('*').alias('count')).collect()

users = list(set([row['userId'] for row in rows]))
out = {
    user: [{'day': row['ymw'], 'value': row['count']} for row in rows if row['userId'] == user ]
    for user in users
}

userIdToClass = dict()
for userId, res in out.items():
    if userId not in userIdToClass:
        user = mydb.collection('users').document(userId).get().to_dict()
        userIdToClass[userId] = user['classId']
    ref = mydb.collection('dataResult').document(
        userIdToClass[userId]).collection('serverComputed').document(userId)
    try:
        doc = ref.get().to_dict()
        doc['activity'] = res
        ref.set(doc)
    except:
        ref.set({
            'activity': res
        })

rows = allBookDf.collect()

users = list(set([row['userId'] for row in rows]))
out = {
    user: {
        row['bookId']: {
            'vc': row['vc'],
            'rc': row['rc'],
            'uperc': row['uperc'],
            'wpm': row['wpm'],
            'score': row['scorePerc'],
            'count': row['count']
        }
        for row in rows if row['userId'] == user
    }
    for user in users
}

userIdToClass = dict()
for userId, res in out.items():
    if userId not in userIdToClass:
        user = mydb.collection('users').document(userId).get().to_dict()
        userIdToClass[userId] = user['classId']
    ref = mydb.collection('dataResult').document(
        userIdToClass[userId]).collection('serverComputed').document(userId)
    try:
        doc = ref.get().to_dict()
        doc['bookPerformance'] = res
        ref.set(doc)
    except:
        ref.set({
            'bookPerformance': res
        })

