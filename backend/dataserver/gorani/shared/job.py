#
# Copyright © 2019 Sunho Kim. All rights reserved.
#

from .context import JobContext, SparkJobContext, StreamJobContext, TFJobContext
from pyspark.sql import SparkSession, DataFrame
from typing import Optional, List

class Job:
    def __init__(self, context: JobContext):
        self.context = context

    def list_input_files(self):
        from os import listdir
        from os.path import isfile, join
        return [join('./in', f) for f in listdir('./in') if isfile(join('./in', f))]

    def input_file_path(self, name: str):
        from os.path import join
        return join('./in', name)

    def log(self, msg: str):
        print(msg)

class SparkJob(Job):
    def __init__(self, context: SparkJobContext):
        Job.__init__(self, context)
        self.context = context

    def read_data_all(self, table: str, cache: bool = False, keyspace: str = 'gorani') -> DataFrame:
        out = self.context.spark.read\
            .format('org.apache.spark.sql.cassandra')\
            .options(table=table, keyspace=keyspace)\
            .load()

        if cache:
            return out.cache()
        return out

    def write_data(self, table: str, df: DataFrame, keyspace: str = 'gorani'):
        df.write\
            .format('org.apache.spark.sql.cassandra')\
            .mode('append')\
            .options(table=table, keyspace=keyspace)\
            .save()

    def write_api(self, table: str, df: DataFrame):
        url = 'jdbc:postgresql://localhost:5432/gorani'
        properties = {'user': 'postgres','password': 'postgres','driver': 'org.postgresql.Driver'}
        df.write\
            .jdbc(url=url, table=table, mode='append', properties=properties)\
            .save()

class PartialSparkJob(SparkJob):
    def __init__(self, context: SparkJobContext):
        SparkJob.__init__(self, context)
        self.nexts = []

    def exec(self, df: DataFrame) -> Optional[DataFrame]:
        tmp = self.partial(df)
        for next in self.nexts:
            if tmp is None:
                return None
            tmp = next.exec(tmp)
        return tmp

    def partial(self, df: DataFrame) -> Optional[DataFrame]:
        raise NotImplementedError

    def __add__(self, other: 'PartialSparkJob') -> 'PartialSparkJob':
        self.nexts.append(other)
        return self

    def __radd__(self, other: DataFrame) -> Optional[DataFrame]:
        return self.exec(other)

class FinalSparkJob(SparkJob):
    def __init__(self, context: SparkJobContext, appname: str):
        SparkJob.__init__(self, context)
        self.context = context
        self.context.init_spark(appname)

class StreamJob(SparkJob):
    def __init__(self, context: StreamJobContext):
        SparkJob.__init__(self, context)
        self.context = context

    def write_data_stream(self, table: str, df: DataFrame, keyspace = 'gorani'):
        return df.writeStream\
            .foreachBatch(lambda df, _: self.write_data(table, df, keyspace=keyspace))

    def write_kafka_stream(self, topic: str, df: DataFrame):
        return df.writeStream\
            .format('kafka')\
            .option('kafka.bootstrap.servers', ','.join(self.context.bokers))\
            .option('topic', topic)

class PartialStreamJob(StreamJob):
    def __init__(self, context: StreamJobContext):
        StreamJob.__init__(self, context)
        self.nexts = []

    def exec(self, df: DataFrame) -> Optional[DataFrame]:
        tmp = self.partial(df)
        for next in self.nexts:
            if tmp is None:
                return None
            tmp = next.exec(tmp)
        return tmp

    def partial(self, df: DataFrame) -> Optional[DataFrame]:
        raise NotImplementedError

    def __add__(self, other: 'PartialStreamJob') -> 'PartialStreamJob':
        self.nexts.append(other)
        return self

    def __radd__(self, other: DataFrame) -> Optional[DataFrame]:
        return self.exec(other)

class FinalStreamJob(StreamJob):
    def __init__(self, context: StreamJobContext, appname: str, topics: List[str]):
        StreamJob.__init__(self, context)
        self.context = context
        self.context.init_spark(appname)
        self.context.init_read_stream(topics)

    def awaitTermination(self):
        self.context.spark.streams.awaitAnyTermination()

class TFJob(Job):
    def __init__(self, context: TFJobContext):
        Job.__init__(self, context)
        self.context = context

