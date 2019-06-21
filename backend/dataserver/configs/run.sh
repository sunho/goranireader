#!/usr/bin/env bash
module lsst
source /tmp/service_name
export PYSPARK_SUBMIT_ARGS = "--master k8s://https://kubernetes:443 --conf spark.driver.host=$SERVICE_NAME --conf spark.kubernetes.container.image=ksunhokim/gorani-stream:v5 --name job --conf spark.executor.instances=1 --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark --conf spark.cassandra.connection.host=cassandra --conf spark.kubernetes.pyspark.pythonVersion=3 --conf spark.kubernetes.driverEnv.GORANI_KAFKA_BROKERS=kafka:9092 --executor-memory 2G --total-executor-cores 1 pyspark-shell"

exec python -m ipykernel $@