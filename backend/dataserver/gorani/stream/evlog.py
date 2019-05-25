from gorani.spark import write_data_stream
from gorani.schema import UserEventLogSchema
from pyspark.sql.functions import from_json, lit
from pyspark.sql import DataFrame
from pyspark.sql.types import StructType
from gorani.utils import binary_to_string, uuid
from . import evlog_to_known_words
from . import evlog_to_sentence_time
from . import evlog_to_exp

def start(sc, spark, stream):
    user_df = get_stream(stream, 'user', UserEventLogSchema)
    evlog_to_exp.start(user_df)
    df = evlog_to_sentence_time.start(user_df)
    evlog_to_known_words.start(spark, df)

def get_stream(stream, name: str, schema: StructType) -> DataFrame:
    df = stream.where('topic = "{}_evlog"'.format(name))
    df = binary_to_string('value', df)\
        .withColumn('value', from_json('value', schema))\
        .select('value.*')

    write_data_stream('{}_event_logs'.format(name), df.withColumn('id', uuid()))\
        .trigger(processingTime='5 seconds')\
        .start()

    return df

