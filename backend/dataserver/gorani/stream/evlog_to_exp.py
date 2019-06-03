from gorani.spark import read_data_all, write_data_stream
from gorani.schema import ProgressBookPayloadSchema
from pyspark.sql.functions import explode, monotonically_increasing_id, udf, from_json
from pyspark.sql.functions import explode, when, col, lit
from pyspark.sql import DataFrame
from typing import Optional


def start(df):
    pr_df = df.where('kind = "progress_book"').select('user_id', from_json(col('payload'), ProgressBookPayloadSchema).alias('payload'))\
            .select('user_id', 'payload.*')
    exp_df = pr_df.select('user_id', 'book_id')
    complete_df = pr_df.where('completed = true').\
                    select('user_id', 'book_id')

    write_data_stream('completed_books', complete_df)\
        .start()

    write_data_stream('experienced_books', exp_df)\
        .start()

    return pr_df
