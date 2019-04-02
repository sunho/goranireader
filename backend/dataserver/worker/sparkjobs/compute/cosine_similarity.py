import pyspark.sql.functions as F
from pyspark.ml.feature import CountVectorizer, Normalizer
from pyspark.mllib.linalg.distributed import IndexedRow, IndexedRowMatrix

from worker.shared import FinalSparkJob, SparkJobContext
from worker.shared.utils import sparse_to_array

class ComputeCosineSimilarity(FinalSparkJob):
    SIMILARITY_TYPE = 'cosine'

    def __init__(self, context: SparkJobContext):
        FinalSparkJob.__init__(self, context, 'Compute Cosine Similarity')

    def compute(self):
        words = self.context.read_data_all('words', cache = True)
        books = self.context.read_data_all('books')

        cv = CountVectorizer()\
            .setInputCol('content')\
            .setOutputCol('tf')\
            .setVocabSize(words.count())
        cv = cv.fit(books)

        nor = Normalizer()\
            .setInputCol('tf')\
            .setOutputCol('norm')

        # normalized book-wordcount matrix
        tf_mat = nor.transform(cv.transform(books))

        # convert to SparseMatrix to BlockMatrix
        mat = IndexedRowMatrix(
        tf_mat.select("id", "norm")\
            .rdd.map(lambda row: IndexedRow(row['id'], row['norm'].toArray())))\
            .toBlockMatrix()

        # cosine similarity
        sim_mat_df = mat.multiply(mat.transpose())\
            .toIndexedRowMatrix()\
            .rows.toDF()

        # change schema
        df = sim_mat_df.select(F.col('index').alias('id'), F.posexplode(sparse_to_array('vector')))\
            .select('id', F.col('pos').alias('other_id'), F.col('col').alias('value'))\
            .withColumn('type', F.lit(ComputeCosineSimilarity.SIMILARITY_TYPE))\
            .where('id != 0 AND other_id != 0')

        self.context.write_data('book_similarity', df)
