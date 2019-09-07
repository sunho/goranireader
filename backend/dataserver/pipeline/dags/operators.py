from consts import SPARK_JOB, PYSPARK_GORANI_MODULE, CREDS, CLUSTER
from airflow.contrib.operators.dataproc_operator import DataprocClusterCreateOperator, \
    DataProcPySparkOperator


def PySparkOperator(name, arguments=[], files=[]):
    return DataProcPySparkOperator(
        main=SPARK_JOB(name),
        task_id='run_'+name,
        cluster_name=CLUSTER,
        arguments=arguments,
        pyfiles=[PYSPARK_GORANI_MODULE],
        files=[CREDS] + files
    )
