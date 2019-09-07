import pyspark
import urllib2
import json
import pyspark.sql.functions as F
from pyspark.sql import SparkSession
from pyspark.sql.functions import explode
from pyspark.sql.functions import from_json, col
from pyspark.sql.functions import count
from pyspark.sql import Row
from pyspark.sql.types import *
from gorani import firebase
from gorani.schema import Book, PaginatePayload

db = firebase.init()
db = firebase.db()
spark = SparkSession.builder.appName('Update Progress').getOrCreate()
docs = db.collection("books").stream()
rows = []
chapIdToName = dict()
for doc in docs:
    response = urllib2.urlopen(doc.to_dict()['downloadLink'])
    data = json.load(response)
    for chap in data['chapters']:
        if chap['title'] == '':
            chapIdToName[chap['id']] = '(blank)'
        else:
            chapIdToName[chap['id']] = chap['title']
        for item in chap['items']:
            rows.append(
                Row(bookId=doc.id, chapterId=chap['id'], sid=item['id']))

booksDf = spark.createDataFrame(rows, Book).cache()

df = spark.read.json("gs://gorani-reader-249509-gorani-reader-event-log")

df2 = df.filter(df['type'] == 'paginate')\
    .withColumn('payload', from_json(col('payload'), PaginatePayload))\
    .withColumn('eltime', col('payload.time'))\
    .withColumn('sids', col('payload.sids'))\
    .withColumn('chapterId', col('payload.chapterId'))\
    .withColumn('bookId', col('payload.bookId'))\
    .withColumn('wordUnknowns', col('payload.wordUnknowns'))\
    .withColumn('sentenceUnknowns', col('payload.sentenceUnknowns'))\
    .drop('payload').drop('serverTime').drop('fireId').drop('type')

minTime = 1000*5
readDf = df2.dropDuplicates(['time', 'userId', 'chapterId', 'eltime'])\
    .filter(df2['eltime'] >= minTime)\
    .withColumn('sid', explode(df2['sids'])).drop('sids')\
    .dropDuplicates(['userId', 'bookId', 'chapterId', 'sid'])\
    .drop('time').drop("wordUnknowns").drop("sentenceUnknowns")


def updateChapterReads():
    interDf = booksDf.join(readDf, ['bookId', 'chapterId', 'sid'], 'inner')

    countDf = interDf.groupBy('userId', 'bookId', 'chapterId').agg(
        count('*').alias('count'))
    totalCountDf = booksDf.groupBy('bookId', 'chapterId').agg(
        count('*').alias('totalCount')).cache()
    chapResDf = countDf.join(totalCountDf, ['bookId', 'chapterId'], 'inner')\
        .withColumn('readPercent', col('count')/col('totalCount'))\
        .drop('count').drop('totalCount')

    chapRes = chapResDf.collect()
    out = dict()
    for res in chapRes:
        if res.userId not in out:
            out[res.userId] = dict()
            if res.bookId not in out[res.userId]:
                out[res.userId][res.bookId] = dict()
        out[res.userId][res.bookId][chapIdToName[res.chapterId]] = res.readPercent

    userIdToClass = dict()

    for userId, res in out.iteritems():
        if userId not in userIdToClass:
            user = db.collection('users').document(userId).get().to_dict()
            userIdToClass[userId] = user['classId']
        ref = db.collection('dataResult').document(
            userIdToClass[userId]).collection('serverComputed').document(userId)
        try:
            doc = ref.get().to_dict()
            doc['chapterReads'] = res
            ref.set(doc)
        except:
            ref.set({
                'chapterReads': res
            })


def updateChapterReadTimes():
    interDf = booksDf.join(readDf, ['bookId', 'chapterId', 'sid'], 'inner')
    chapTimeDf = interDf.groupBy('userId', 'bookId', 'chapterId').agg(
        F.sum('eltime').alias('eltime'))
    chapRes = chapTimeDf.collect()

    out = dict()
    for res in chapRes:
        if res.userId not in out:
            out[res.userId] = dict()
            if res.bookId not in out[res.userId]:
                out[res.userId][res.bookId] = dict()
        out[res.userId][res.bookId][chapIdToName[res.chapterId]] = res.eltime

    userIdToClass = dict()
    for userId, res in out.iteritems():
        if userId not in userIdToClass:
            user = db.collection('users').document(userId).get().to_dict()
            userIdToClass[userId] = user['classId']
        ref = db.collection('dataResult').document(
            userIdToClass[userId]).collection('serverComputed').document(userId)
        try:
            doc = ref.get().to_dict()
            doc['chapterReadTimes'] = res
            ref.set(doc)
        except:
            ref.set({
                'chapterReadTimes': res
            })


def updateBookReadTimes():
    interDf = booksDf.join(readDf, ['bookId', 'chapterId'], 'inner')
    bookTimeDf = interDf.groupBy('userId', 'bookId').agg(
        F.sum('eltime').alias('eltime'))
    bookRes = bookTimeDf.collect()

    out = dict()
    for res in bookRes:
        if res.userId not in out:
            out[res.userId] = dict()
        out[res.userId][res.bookId] = res.eltime

    userIdToClass = dict()
    for userId, res in out.iteritems():
        if userId not in userIdToClass:
            user = db.collection('users').document(userId).get().to_dict()
            userIdToClass[userId] = user['classId']
        ref = db.collection('dataResult').document(
            userIdToClass[userId]).collection('serverComputed').document(userId)
        try:
            doc = ref.get().to_dict()
            doc['bookReadTimes'] = res
            ref.set(doc)
        except:
            ref.set({
                'bookReadTimes': res
            })


def updateBookReads():
    interDf = booksDf.join(readDf, ['bookId'], 'inner')
    countDf = interDf.groupBy('userId', 'bookId').agg(
        count('*').alias('count')).cache()
    totalCountDf = booksDf.groupBy('bookId').agg(
        count('*').alias('totalCount'))
    bookResDf = countDf.join(totalCountDf, ['bookId'], 'inner')\
        .withColumn('readPercent', col('count')/col('totalCount'))\
        .drop('count').drop('totalCount')

    bookRes = bookResDf.collect()

    out = dict()
    for res in bookRes:
        if res.userId not in out:
            out[res.userId] = dict()
        out[res.userId][res.bookId] = res.readPercent

    userIdToClass = dict()
    for userId, res in out.iteritems():
        if userId not in userIdToClass:
            user = db.collection('users').document(userId).get().to_dict()
            userIdToClass[userId] = user['classId']
        ref = db.collection('dataResult').document(
            userIdToClass[userId]).collection('serverComputed').document(userId)
        try:
            doc = ref.get().to_dict()
            doc['bookReads'] = res
            ref.set(doc)
        except:
            ref.set({
                'bookReads': res
            })

updateBookReads()
updateChapterReads()
updateBookReadTimes()
updateChapterReadTimes()
