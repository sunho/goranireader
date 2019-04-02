from pyspark.sql import SparkSession, DataFrame
from typing import List
from .datadb import DataDB

class JobContext:
    def __init__(self):
        self.data_db = DataDB()

class SparkJobContext(JobContext):
    def __init__(self):
        JobContext.__init__(self)

    def init_spark(self, appname: str):
        self.spark = SparkSession\
            .builder\
            .appName(appname)\
            .getOrCreate()
class StreamJobContext(SparkJobContext):
    def __init__(self, brokers: List[str]):
        SparkJobContext.__init__(self)
        self.brokers = brokers

    def init_read_stream(self, topics: List[str]):
        self.stream = self.spark\
            .readStream\
            .format('kafka')\
            .option('kafka.bootstrap.servers', ','.join(self.brokers))\
            .option('subscribe', ','.join(topics))\
            .load()
