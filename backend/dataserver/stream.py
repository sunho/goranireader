from gorani.spark import read_kafka_stream
from gorani.stream import evlog
from pyspark.sql import SparkSession, DataFrame

spark = SparkSession\
    .builder\
    .appName('Stream')\
    .getOrCreate()

sc = spark.sparkContext

evlog_stream = read_kafka_stream(spark, ['user_evlog', 'system_evlog'])

evlog.start(sc, spark, evlog_stream)
spark.streams.awaitAnyTermination()
