from pyspark.sql.types import *

UnknownWord = StructType([
    StructField("sentenceId", StringType()),
    StructField("word", StringType()),
    StructField("wordIndex", IntegerType()),
    StructField("time", IntegerType())
])

UnknownSentence = StructType([
    StructField("sentenceId", StringType()),
    StructField("time", IntegerType())
])

PaginatePayload = StructType([
    StructField("bookId", StringType()),
    StructField("chapterId", StringType()),
    StructField("time", IntegerType()),
    StructField("sids", ArrayType(StringType())),
    StructField("wordUnknowns", ArrayType(UnknownWord)),
    StructField("sentenceUnknowns", ArrayType(UnknownSentence))
])

Book = StructType([StructField('bookId', StringType()), StructField(
    'chapterId', StringType()), StructField('sid', StringType())])
