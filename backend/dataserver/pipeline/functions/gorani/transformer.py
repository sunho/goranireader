from pyspark import Row
from pyspark.sql.functions import udf, pandas_udf
import pyspark.sql.functions as F
from pyspark.sql.functions import from_json, explode, col
from pyspark.sql.types import *

from .gorani import Gorani
from .schema import PaginatePayload
from .timeutil import parse_ts, parse_date
from ._udf_impl import _UdfImpl

class PipeInto(object):
    def __init__(self, instance, func, args, kwargs):
        self.data = {'function': func}
        if instance is not None:
            self.data['instance'] = instance
        self.data['args'] = args
        self.data['kwargs'] = kwargs

    def __call__(self, other):
        if 'instance' in self.data:
            return self.data['function'](
                self.data['instance'],
                other,
                *self.data['args'], 
                **self.data['kwargs']
            )
        else:
            return self.data['function'](
                other,
                *self.data['args'], 
                **self.data['kwargs']
            )

class piper(object):
    def __init__(self, f):
        self.func = f
        self.instance = None

    def __call__(self, *args, **kwargs):
      return PipeInto(self.instance, self.func, args, kwargs)

    def __get__(self, instance, owner):
        self.instance = instance
        return self

from pyspark.sql.dataframe import DataFrame

def pipe(self, f):
    return f(self)

DataFrame.n = pipe

class Transformer:
    def __init__(self, gorani, spark, sc):
        self.gorani = gorani
        self.spark = spark
        self.sc = sc

        self._udf_impl = _UdfImpl(gorani)
        self.stem = pandas_udf(self._udf_impl.stem, StringType())
        self.get_sentence = pandas_udf(self._udf_impl.get_sentence, StringType())
        self.get_content= pandas_udf(self._udf_impl.get_content, StringType())
        self.get_username = pandas_udf(self._udf_impl.get_username, StringType())
        self.get_questions_len = pandas_udf(self._udf_impl.get_questions_len, IntegerType())
        self.init_book()
        print("Transformet Inited")

    def init_book(self):
        book_rows = list()
        for id, book in self.gorani.books.items():
            for chap in book['chapters']:
                for item in chap['items']:
                    book_rows.append(Row(bookId=id, chapterId=chap['id'], sid=item['id']))
        schema = StructType([StructField('bookId', StringType()), StructField('chapterId',StringType()), StructField('sid', StringType())])
        self.booksDf = self.spark.createDataFrame(book_rows, schema).cache()

    @piper
    def parse_paginate(self, df):
        return df.filter(df['type'] == 'paginate')\
            .withColumn('payload', from_json(col('payload'), PaginatePayload))\
            .withColumn('eltime', col('payload.time'))\
            .withColumn('sids', col('payload.sids'))\
            .withColumn('chapterId', col('payload.chapterId'))\
            .withColumn('bookId', col('payload.bookId'))\
            .withColumn('wordUnknowns', col('payload.wordUnknowns'))\
            .withColumn('sentenceUnknowns', col('payload.sentenceUnknowns'))\
            .drop('payload').drop('serverTime').drop('fireId').drop('type')\
            .dropDuplicates(['time', 'userId', 'chapterId', 'eltime'])

    @piper
    def parse_time(self, df):
        return df.withColumn('ts', parse_ts(col('time')))\
            .withColumn('date', parse_date(col('ts')))

    @piper
    def explode_column(self, df, i, o):
        return df.withColumn(o, explode(col(i))).drop(i)

    @piper
    def stem_column(self, df, i, o):
        return df.withColumn(o, self.stem(col(i)))\
            .filter(col(o) != 'STOPSTOP')

    minTime = 1000
    @piper
    def filter_cheat(self, df):
        return df.filter(col('eltime') >= self.minTime)

    @piper
    def calculate_percent(self, df, booksDf, group, o):
        interDf = booksDf.join(df.dropDuplicates(['userId', 'sid'] + group), group + ['sid'], 'inner')
        countDf = interDf.groupBy(*(['userId'] + group)).agg(
            F.count('*').alias('_count'))
        totalCountDf = booksDf.groupBy(group).agg(
            F.count('*').alias('_totalCount')).cache()
        return countDf.join(totalCountDf, group, 'inner')\
            .withColumn(o, col('_count')/col('_totalCount'))\
            .drop('_count').drop('_totalCount')

    @piper
    def calculate_read_percent(self, df, booksDf, group, o):
        return df.n(self.filter_cheat())\
            .n(self.explode_column('sids', 'sid'))\
            .n(self.calculate_percent(booksDf, group, o))

    @piper
    def calculate_read_time(self, df, books_df, group, o):
        inter_df = books_df.dropDuplicates(group).join(df, group, 'inner')
        return inter_df.groupBy(*(['userId'] + group)).agg(
            F.sum('eltime').alias(o))
            
    @piper
    def filter_by_mission(self, df, mission):
        return df.filter(col('ts') < mission['due'])\
            .filter(col('bookId') == mission['bookId'])\
            .filter(col('classId') == mission['classId'])\
            .filter(col('chapterId').isin(mission['chapters']))

    @piper
    def parse_unknown_words(self, df):
        return df.n(self.explode_column('wordUnknowns', 'wordUnknown'))\
            .withColumn('word', col('wordUnknown.word'))\
            .n(self.stem_column('word', 'stem'))\
            .withColumn('sid', col('wordUnknown.sentenceId'))\
            .dropDuplicates(["userId", "time", "word"])\
            .drop('wordUnknown')