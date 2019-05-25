def read_data_all(spark, table: str, cache: bool = False, keyspace: str = 'gorani'):
    out = spark.read\
        .format('org.apache.spark.sql.cassandra')\
        .options(table=table, keyspace=keyspace)\
        .load()

    if cache:
        return out.cache()
    return out

def write_data(table: str, df, keyspace: str = 'gorani'):
    df.write\
        .format('org.apache.spark.sql.cassandra')\
        .mode('append')\
        .options(table=table, keyspace=keyspace)\
        .save()

def write_data_stream(table: str, df, keyspace = 'gorani'):
    return df.writeStream\
        .foreachBatch(lambda df, _: write_data(table, df, keyspace=keyspace))

def read_kafka_stream(spark, topics, brokers):
    return spark.readStream\
        .format('kafka')\
        .option('kafka.bootstrap.servers', ','.join(brokers))\
        .option('subscribe', ','.join(topics))\
        .load()
