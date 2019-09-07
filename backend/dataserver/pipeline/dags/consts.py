from airflow.models import Variable
BUCKET = Variable.get('gcs_bucket')
PYSPARK_GORANI_MODULE = 'gs://' + BUCKET + '/gorani.zip'
PROJECT = Variable.get('gcs_project')
CREDS = 'gs://' + BUCKET + '/key.json'
CLUSTER = Variable.get('gcs_cluster')

def SPARK_JOB(name):
    return 'gs://' + BUCKET + '/spark-jobs/' + name + '.py'
