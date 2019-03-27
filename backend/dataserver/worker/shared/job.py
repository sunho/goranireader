from .context import JobContext, SparkJobContext
from common import DataDB
from pyspark.sql import SparkSession

class Job:
    def __init__(self):
        self.context = JobContext()
        self.data_db = DataDB()

class SparkJob(Job):
    def __init__(self, appname):
        Job.__init__(self)
        self.spark = SparkSession \
        .builder \
        .appName(appname) \
        .getOrCreate()

        self.context = SparkJobContext(self.spark)
