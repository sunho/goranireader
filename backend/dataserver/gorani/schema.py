#
# Copyright © 2019 Sunho Kim. All rights reserved.
#

from pyspark.sql.types import *

UserEventLogSchema = StructType(
    [
        StructField('user_id', IntegerType()),
        StructField('kind', StringType()),
        StructField('day', TimestampType()),
        StructField('payload', StringType()),
        StructField('time', TimestampType())
    ]
)

FlipPageUword = StructType(
    [
        StructField('index', IntegerType()),
        StructField('interval', DoubleType())
    ]
)

FilpPageSentence = StructType(
    [
        StructField('sentence', StringType()),
        StructField('uwords', ArrayType(FlipPageUword))
    ]
)

FlipPagePayloadSchema = StructType(
    [
        StructField('book_id', IntegerType()),
        StructField('type', StringType()),
        StructField('chpater', IntegerType()),
        StructField('page', IntegerType()),
        StructField('interval', DoubleType()),
        StructField('sentences', ArrayType(FilpPageSentence))
    ]
)

ProgressBookPayloadSchema = StructType(
    [
        StructField('book_id', IntegerType()),
        StructField('completed', BooleanType())
    ]
)
