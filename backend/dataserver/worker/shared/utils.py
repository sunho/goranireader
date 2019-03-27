import pyspark.sql.functions as F
from pyspark.sql import types as T
from pyspark.ml.linalg import SparseVector, DenseVector

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
