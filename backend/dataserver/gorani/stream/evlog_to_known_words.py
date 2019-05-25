from gorani.spark import read_data_all, write_data_stream
from pyspark.sql.functions import explode, when, col, lit
from pyspark.sql import DataFrame
from typing import Optional


def start(spark, df):
    words = read_data_all(spark, 'words').cache()

    nword_df = df.select('user_id', explode('paragraph').alias('part'))\
        .select('user_id', 'part.word', 'part.uword')\
        .withColumn('score', when(col('uword') == False, 1).otherwise(-3))\
        .join(words.withColumnRenamed('word', 'word2'), col('word') == col('word2'), 'left_semi')\
        .drop('uword')

    write_data_stream('user_known_words', nword_df)\
        .start()

    return nword_df
