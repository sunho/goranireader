export SPARK_SUBMIT=/etc/spark/bin/spark-submit
export SPARK_ARGS="$SPARK_ARGS --master spark://localhost:7077"
export ARGS="$@"

cd dataserver && make run-spark
