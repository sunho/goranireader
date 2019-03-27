class JobContext:
    def __init__(self):
        pass

    def list_input_files(self):
        from os import listdir
        from os.path import isfile, join
        return [join('./in', f) for f in listdir('./in') if isfile(join('./in', f))]

    def input_file_path(self, name):
        from os.path import join
        return join('./in', name)

    def log(self, msg):
        print(msg)

class SparkJobContext(JobContext):
    def __init__(self, spark):
        JobContext.__init__(self)
        self.spark = spark

    def read_data_all(self, table, cache = False, **kwargs):
        out = self.spark.read\
        .format('org.apache.spark.sql.cassandra')\
        .options(table=table, keyspace='gorani')\
        .load()

        if cache:
            return out.cache()
        return out

    def write_data(self, table, df, **kwargs):
        df.write\
        .format('org.apache.spark.sql.cassandra')\
        .mode('append')\
        .options(table=table, keyspace='gorani')\
        .save()
