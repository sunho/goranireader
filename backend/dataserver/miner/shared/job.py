from .context import JobContext
from pyspark.sql import SparkSession

class Job:
    def __init__(self, appname):
        self.spark = SparkSession \
        .builder \
        .appName(appname) \
        .getOrCreate()

        self.context = JobContext(self.spark)