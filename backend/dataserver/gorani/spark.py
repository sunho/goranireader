def read_data_all(spark, table: str, cache: bool = False, keyspace: str = 'gorani'):
    out = spark.read\
        .format('org.apache.spark.sql.cassandra')\
        .options(table=table, keyspace=keyspace)\
        .load()

    if cache:
        return out.cache()
    return out

def read_api_all(spark, table: str, cache: bool = False):
    url = 'jdbc:postgresql://localhost:5432/postgres'
    properties = {'user': 'postgres','password': 'postgres','driver': 'org.postgresql.Driver'}
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
    url = 'jdbc:postgresql://localhost:5432/postgres'
    properties = {'user': 'postgres','password': 'postgres','driver': 'org.postgresql.Driver'}
    df.write\
        .jdbc(url=url, table=table, mode='append', properties=properties)

def write_data_stream(table: str, df, keyspace = 'gorani'):
    return df.writeStream\
        .foreachBatch(lambda df, _: write_data(table, df, keyspace=keyspace))

def read_kafka_stream(spark, topics, brokers):
    return spark.readStream\
        .format('kafka')\
        .option('kafka.bootstrap.servers', ','.join(brokers))\
        .option('subscribe', ','.join(topics))\
        .load()
