import matplotlib
matplotlib.use('Agg')

from gcloud import storage
import uuid
import reportng
import seaborn

from pyspark.sql import SparkSession
spark = SparkSession.builder.appName('Create Mission Report').getOrCreate()
sc = spark.sparkContext
df = spark.read.json("gs://gorani-reader-249509-gorani-reader-event-log")

from pyspark.sql.functions import from_json, explode, col
import pyspark.sql.functions as F
from gorani.transformer import Transformer
from gorani.timeutil import to_timestamp, utc
from gorani.gorani import Gorani
from pyspark.ml.feature import CountVectorizer
from pyspark.ml.regression import LinearRegression
from pyspark.sql.types import *
from pyspark.sql.functions import explode
from gorani import firebase
import datetime
from datetime import timedelta

plot = seaborn.pointplot(x=[1], y=[1])

firebase.init('spark')
mydb = firebase.db()
gorani = Gorani(mydb)
transformer = Transformer(gorani, spark, sc)
paginateDf = df.n(transformer.parse_paginate())\
    .n(transformer.parse_time())


def get_current_missions(after_due=False):
    docs = mydb.collection("classes").stream()
    missions = list()
    for doc in docs:
        data = doc.to_dict()
        if 'mission' in data:
            m = data['mission']
            out = {
                'classId': doc.id,
                'bookId': m['bookId'],
                'chapters': m.get('chapters', []),
                'due': to_timestamp(m['due'] + timedelta(hours=2)),
                'date': m['due'].strftime('%m/%d'),
                'message': m['message']
            }
            if after_due:
                if m['due'] < datetime.datetime.now(utc):
                    missions.append(out)
            else:
                missions.append(out)
    return missions


def predict_difficult_sentences(sid_df):
    cv = CountVectorizer(inputCol="sids", outputCol="features")
    cv_model = cv.fit(sid_df)
    trainDf = sid_df.n(cv_model.transform)
    lr = LinearRegression(
        labelCol='eltime', featuresCol='features').fit(trainDf)
    inputDf = sid_df.n(transformer.explode_column('sids', 'sid'))\
        .select('bookId', 'chapterId', 'sid')\
        .dropDuplicates(['sid'])\
        .withColumn('sids', F.array(col('sid')))\
        .drop('sid')\
        .n(cv_model.transform)
    resDf = lr.transform(inputDf).select(
        'bookId', 'chapterId', 'sids', col('prediction').alias('eltime'))
    resDf = resDf.n(transformer.explode_column('sids', 'sid'))\
        .withColumn('sentence', transformer.get_sentence(col('bookId'), col('chapterId'), col('sid')))\
        .filter(col('sentence') != '.').select('sentence', 'eltime')\
        .dropDuplicates(['eltime']).orderBy('eltime', ascending=False)\
        .limit(5)
    trainingSummary = lr.summary
    return ([row['sentence'] for row in resDf.collect()], trainingSummary.r2)


def calculate_vocab(df):
    uwordDf = df.n(transformer.parse_unknown_words())\
        .withColumn('content', transformer.get_sentence(col('bookId'), col('chapterId'), col('sid')))
    topDf = uwordDf.groupBy('stem').agg(F.count('*').alias('count'))\
        .orderBy('count', ascending=False)\
        .filter(col('count') != 1).limit(15)
    vocabDf = topDf.join(uwordDf.dropDuplicates(['stem']), ['stem'], 'inner')\
        .orderBy('count', ascending=False)\
        .select('count', 'word', 'content')
    return vocabDf.collect()


def calculate_unknown_sentences(df):
    usenDf = df.n(transformer.explode_column('sentenceUnknowns', 'sentenceUnknown'))\
        .select(col('sentenceUnknown.sentenceId').alias('sid'), 'chapterId', 'bookId', 'userId')\
        .withColumn('sentence', transformer.get_sentence(col('bookId'), col('chapterId'), col('sid')))\
        .withColumn('username', transformer.get_username(col('userId')))\
        .dropDuplicates(['sentence', 'username'])\
        .select('sentence', 'username')\
        .groupBy('sentence')\
        .agg(F.collect_list("username").alias('users'))
    return usenDf.collect()


def calculate_date_progress(df, mission):
    mbooksDf = transformer.booksDf.filter(
        col('chapterId').isin(mission['chapters'])).cache()
    today = datetime.datetime.fromtimestamp(mission['due']).strftime('%m/%d')
    rows = list()
    for i in range(0, 11):
        t = mission['due'] - 24*60*60*i
        rows.extend(df.filter(col('ts') < t)
                    .n(transformer.calculate_read_percent(mbooksDf, ['bookId'], 'percent'))
                    .drop('bookId')
                    .withColumn('date', F.lit(datetime.datetime.fromtimestamp(t).strftime('%m/%d'))).collect())
    schema = StructType([StructField('userId', StringType()), StructField(
        'percent', DoubleType()), StructField('date', StringType())])
    progressDf = sc.parallelize(rows).toDF(schema)
    today = datetime.datetime.fromtimestamp(mission['due']).strftime('%m/%d')
    total = progressDf.filter(col('date') == today).count()
    return progressDf.groupBy('date').agg((F.sum('percent')).alias('tot'))\
        .withColumn('avgPercent', col('tot')/total)\
        .drop('tot').collect()


def calculate_progress(df, mission):
    mbooksDf = transformer.booksDf.filter(
        col('chapterId').isin(mission['chapters'])).cache()
    timeDf = df.filter(col('ts') < mission['due'])\
        .n(transformer.calculate_read_time(mbooksDf, ['bookId'], 'eltime'))
    percentDf = df.filter(col('ts') < mission['due'])\
        .n(transformer.calculate_read_percent(mbooksDf, ['bookId'], 'percent'))
    return timeDf.join(percentDf, ['userId'], 'inner')\
        .withColumn('username', transformer.get_username(col('userId')))\
        .withColumn('clear', F.when(col("percent") >= 0.8, True).otherwise(False))\
        .select('username', 'clear', 'eltime', 'percent')\
        .collect()


missions = get_current_missions(after_due=True)
print("missions:", len(missions))
report_data = list()
for mission in missions:
    print("generating: ", mission['classId'])
    total = len(list(mydb.collection('users').where(
        u'classId', u'==', mission['classId']).stream()))
    classDf = paginateDf.n(transformer.filter_by_mission(mission)).cache()
    progresses = calculate_progress(classDf, mission)
    sn = sum([1 if row['clear'] else 0 for row in progresses])
    fn = sum([0 if row['clear'] else 1 for row in progresses])
    vocab = calculate_vocab(classDf)
    sidDf = classDf.select('bookId', 'chapterId', 'sids', 'eltime').cache()
    dsens = predict_difficult_sentences(sidDf)
    activityDf = classDf.n(transformer.explode_column('sids', 'sid'))\
        .groupBy('date').agg(F.count('*').alias('count'))\
        .orderBy('date')
    activity = activityDf.collect()
    usens = calculate_unknown_sentences(classDf)
    date_progresses = calculate_date_progress(classDf, mission)

    report_data.append(
        {
            'date': mission['date'],
            'message': mission['message'],
            'class_id': mission['classId'],
            'total_number': total,
            'success_number': sn,
            'failure_number': fn,
            'progress': progresses,
            'vocab': vocab,
            'difficult_sentences': dsens[0],
            'difficult_accuracy': dsens[1],
            'unknown_sentences': usens,
            'activity': activity,
            'date_progress': date_progresses
        }
    )


client = storage.Client()
bucket = client.get_bucket('gorani-reader-reports')


def ms_to_str(ms):
    hours = ms / (3600 * 1000)
    ms = ms % (3600 * 1000)
    minutes = ms / (60 * 1000)
    ms = ms % (60 * 1000)
    seconds = ms / (1000)
    return "{}h {}m {}s".format(hours, minutes, seconds)


def upload(ext, path):
    h = str(uuid.uuid1())
    blob = bucket.blob(h + '.' + ext)
    with open(path, 'rb') as photo:
        blob.upload_from_file(photo)
    return blob.public_url


for report in report_data:
    print("uploading: ", report['class_id'])
    r = reportng.ReportWriter(report_name='Mission Report',
                              brand='Gorani Reader')
    out = r.report_header(theme='pulse')

    students = sorted(report['progress'],
                      key=lambda x: x['eltime'], reverse=True)
    rows = [(student['username'], 'Yes' if student['clear'] else 'No', ms_to_str(student['eltime'])) for student in students]
    if len(rows) != 0:
        out += r.report_table(*rows, header=("Name", "Completed", "Spent time"), title="Progress")
    points = sorted(report['date_progress'], key=lambda x: x['date'])
    plot = seaborn.pointplot(x=[row['date'] for row in points], y=[
                             row['avgPercent'] for row in points])
    fig = plot.get_figure()
    fig.savefig("date.png")

    out += r.report_cards(('info', 'Number of total students', str(report['total_number'])),
                          ('info', 'Number of students who tried',
                           str(report['success_number'] + report['failure_number'])),
                          ('success', 'Number of students who completed',
                           str(report['success_number'])),
                          ('danger', 'Number of students who tried but failed to complete',
                           str(report['failure_number'])),
                          ('warning', 'Number of students who didn\'t even try',
                           str(report['total_number'] - (report['success_number'] + report['failure_number']))),
                          title="Insights")

    rows = [(row['sentence'], ','.join(row['users'])) for row in report['unknown_sentences']]
    if len(rows) != 0:
        out += r.report_table(*rows, header= ("Sentence", 'Students'), title="Unknown Sentences marked by students")

    out += r.report_section('Average progress of students who tried', "")
    out += r.report_image_carousel(upload('png', 'date.png'))

    out += r.report_section(
        'Activity of students by dates', "")
    points = sorted(report['activity'], key=lambda x: x['date'])
    plot = seaborn.barplot(x=[row['date'] for row in points], y=[
                           row['count'] for row in points])
    fig = plot.get_figure()
    fig.savefig("activity.png")

    out += r.report_image_carousel(upload('png', 'activity.png'))

    rows = [(row['word'], row['count'], row['content']) for row in report['vocab']]
    if len(rows) != 0:
        out += r.report_table(*rows, header=("Word", "Count", "Context"), title="Vocab")

    out += r.report_section(
        'Difficult Sentences', "The sentences that are predicted to be diffcult with accuracy " + str(
            report['difficult_accuracy'] * 100) + "%")

    rows = [(row,) for row in report['difficult_sentences']]
    if len(rows) != 0:
        out += r.report_table(*rows, header=("Sentence",), section=False)

    h = str(uuid.uuid1())
    blob = bucket.blob(h + '.html')
    blob.upload_from_string(out, content_type='text/html; charset=utf-8')
    ref = mydb.collection('dataResult').document(
        report['class_id']).collection('reports').document()
    ref.set({
        'link': blob.public_url.decode("utf-8"),
        'name': report['message'] + u' Mission Report',
        'time': report['date'].decode('utf-8')
    })
    ref = mydb.collection('classes').document(report['class_id'])
    doc = ref.get().to_dict()
    del doc['mission']
    ref.set(doc)
