from gorani.shared import FinalSparkJob, SparkJobContext
from pyspark.sql.functions import udf, lit, col
from gorani.shared.utils import uuid
from pyspark.sql.types import *

def _calculate_distance(word: str, word2: str):
    w = word.split(' ')
    w.reverse()
    w2 = word2.split(' ')
    w2.reverse()
    l = min(len(w), len(w2))
    score = 0
    for i in range(l):
        if w[i] == w2[i]:
            score += 1
        else:
            break
    return score

calculate_distance = udf(_calculate_distance, IntegerType())

class ComputeSimilarWord(FinalSparkJob):
    def __init__(self, context: SparkJobContext):
        FinalSparkJob.__init__(self, context, 'Compute Word Similarity')

    def compute(self):
        df = self.read_data_all('words').select('word', 'pron').cache()
        out_df = df.alias('df').crossJoin(df.alias('df2'))\
            .filter('df.word != df2.word')\
            .select('df.word', col('df2.word').alias('other_word'), calculate_distance('df.pron', 'df2.pron').alias('score'))\
            .withColumn('kind', lit('rhyme'))\
            .withColumn('id', uuid())\
            .filter('score > 2')

        self.write_api('similar_words', out_df)
