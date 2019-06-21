import os
from pyspark.sql.types import *

def read_data_all(spark, table: str, cache: bool = False, keyspace: str = 'gorani'):
    out = spark.read\
        .format('org.apache.spark.sql.cassandra')\
        .options(table=table, keyspace=keyspace)\
        .load()

    if cache:
        return out.cache()
    return out

def read_api_all(spark, table: str, cache: bool = False):
    addr = os.environ['GORANI_USER_DB_ADDR']
    db = os.environ['GORANI_USER_DB_DB']
    url = 'jdbc:postgresql://{}:5432/{}'.format(addr, db)
    user = os.environ['GORANI_USER_DB_USER']
    pw = os.environ['GORANI_USER_DB_PASS']
    properties = {'user': user,'password': pw,'driver': 'org.postgresql.Driver'}
    out = spark.read\
        .jdbc(url=url, table=table, properties=properties)\

    if cache:
        return out.cache()
    return out

def write_data(table: str, df, keyspace: str = 'gorani'):
    df.write\
        .format('org.apache.spark.sql.cassandra')\
        .mode('append')\
        .options(table=table, keyspace=keyspace)\
        .save()

def write_api(table: str, df):
    url = 'jdbc:postgresql://postgres-postgresql:5432/postgres'
    properties = {'user': 'postgres','password': 'postgres','driver': 'org.postgresql.Driver', 'stringtype': 'unspecified'}
    df.write\
        .jdbc(url=url, table=table, mode='append', properties=properties)

def write_data_stream(table: str, df, keyspace = 'gorani'):
    return df.writeStream\
        .foreachBatch(lambda df, _: write_data(table, df, keyspace=keyspace))

def read_kafka_stream(spark, topics):
    return spark.readStream\
        .format("redis")\
        .option("stream.keys",','.join(topics))\
        .schema(StructType([StructField("topic", StringType()),StructField("value", StringType())]))\
        .load()
