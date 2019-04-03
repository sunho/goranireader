from gorani.shared import PartialStreamJob, StreamJobContext
from pyspark.sql.functions import explode, when, col, lit
from pyspark.sql import DataFrame
from typing import Optional

class TransformToKnownWordsJob(PartialStreamJob):
    def __init__(self, context: StreamJobContext):
        PartialStreamJob.__init__(self, context)

    def partial(self, df: DataFrame) -> Optional[DataFrame]:
        words = self.read_data_all('words').cache()

        nword_df = df.select('user_id', explode('paragraph').alias('part'))\
            .select('user_id', 'part.word', 'part.uword')\
            .withColumn('score', when(col('uword') == False, 1).otherwise(-3))\
            .join(words.withColumnRenamed('word', 'word2'), col('word') == col('word2'), 'left_semi')\
            .drop('uword')

        self.write_data_stream('user_known_words', nword_df)\
            .start()

        return None
