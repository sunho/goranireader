from datetime import datetime
from airflow import DAG
from operators import CreateClusterOperator, PySparkOperator, DeleteClusterOperator
from consts import PROJECT
import uuid
args = {
    'start_date': datetime(2019, 9, 27),
    'depends_on_past': False,
    'owner': 'airflow',
    'project_id': PROJECT
}


with DAG('create_mission_report', default_args=args) as dag:
    # create_cluster = CreateClusterOperator()
    job = PySparkOperator('create_mission_report')
    job 