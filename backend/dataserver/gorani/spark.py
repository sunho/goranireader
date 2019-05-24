def read_data_all(sc, table: str, cache: bool = False, keyspace: str = 'gorani'):
    out = sc.read\
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
