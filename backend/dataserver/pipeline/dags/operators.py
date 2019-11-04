from consts import SPARK_JOB, PYSPARK_GORANI_MODULE, CREDS, PROJECT, INIT
from airflow.contrib.operators.dataproc_operator import DataprocClusterCreateOperator, \
    DataProcPySparkOperator, DataprocClusterDeleteOperator
import uuid

def start(self):
    """
    Create a new cluster on Google Cloud Dataproc.
    """
    self.log.info('Creating cluster: %s', self.cluster_name)
    cluster_data = self._build_cluster_data()
    cluster_data['config']['softwareConfig']['optionalComponents'] = ['ANACONDA']

    return (
        self.hook.get_conn().projects().regions().clusters().create(  # pylint: disable=no-member
            projectId=self.project_id,
            region=self.region,
            body=cluster_data,
            requestId=str(uuid.uuid4()),
        ).execute())

DataprocClusterCreateOperator.start = start



def CreateClusterOperator():
    out = DataprocClusterCreateOperator(
        task_id='start_cluster',
        cluster_name="cluster-{{ execution_date.strftime('%y%m%d%S%f') }}",
        project_id=PROJECT,
        num_masters=1,
        num_workers=2,
        num_preemptible_workers=2,
        metadata={'PIP_PACKAGES': 'firebase-admin seaborn nltk iso8601 reportng gcloud pyarrow==0.13.0'},
        init_actions_uris=['gs://dataproc-initialization-actions/python/pip-install.sh'],
        worker_machine_type="n1-standard-2",
        master_machine_type="n1-standard-2",
        master_disk_type="pd-ssd",
        worker_disk_type="pd-ssd",
        properties={
            'spark:spark.executorEnv.PYTHONHASHSEED': '0',
            'spark:spark.yarn.am.memory': '1024m',
            'spark:spark.sql.avro.compression.codec': 'deflate'
        },
        worker_disk_size=50,
        master_disk_size=50,
        zone='asia-northeast1-b'
    )

    return out

def PySparkOperator(name, arguments=[], files=[]):
    return DataProcPySparkOperator(
        main=SPARK_JOB(name),
        task_id='run_'+name,
        cluster_name="cluster-{{ execution_date.strftime('%y%m%d%S%f') }}",
        arguments=arguments,
        pyfiles=[PYSPARK_GORANI_MODULE],
        files=[CREDS] + files
    )

def DeleteClusterOperator():
    return DataprocClusterDeleteOperator(
        task_id='stop_cluster',
        project_id=PROJECT,
        cluster_name="cluster-{{ execution_date.strftime('%y%m%d%S%f')}}",
        trigger_rule='all_done'
    )
