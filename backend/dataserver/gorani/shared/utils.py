import pyspark.sql.functions as F
from pyspark.sql import types as T
from pyspark.sql import DataFrame
from pyspark.sql.functions import from_json, col
from pyspark.ml.linalg import SparseVector, DenseVector
from uuid import uuid4
import pickle

# https://danvatterott.com/blog/2018/07/08/aggregating-sparse-and-dense-vectors-in-pyspark/
def _sparse_to_array(v):
  v = DenseVector(v)
  new_array = list([float(x) for x in v])
  return new_array

sparse_to_array = F.udf(_sparse_to_array, T.ArrayType(T.FloatType()))

# https://danvatterott.com/blog/2018/07/08/aggregating-sparse-and-dense-vectors-in-pyspark/
def _dense_to_array(v):
  new_array = list([float(x) for x in v])
  return new_array

dense_to_array = F.udf(_dense_to_array, T.ArrayType(T.FloatType()))

def _uuid():
    return str(uuid4())

uuid = F.udf(_uuid, T.StringType())

def _pickle_dump(col):
    return pickle.dumps(col)

pickle_dump = F.udf(_pickle_dump, T.BinaryType())

def binary_to_string(column: str, df: DataFrame) -> DataFrame:
    return df.withColumn(column, col(column).cast(T.StringType()))
