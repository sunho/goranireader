class JobContext:
    def __init__(self, spark):
        self.spark = spark

        self.words = spark.read.format("org.apache.spark.sql.cassandra")\
        .options(table="words", keyspace="gorani")\
        .load()