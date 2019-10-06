from datetime import datetime
from airflow import DAG
from operators import CreateClusterOperator, PySparkOperator, DeleteClusterOperator
from consts import PROJECT
import uuid
args = {
    'start_date': datetime(2019, 9, 28),
    'depends_on_past': False,
    'owner': 'airflow',
    'project_id': PROJECT
}


with DAG('create_mission_report', default_args=args, schedule_interval='0 9,23 * * *') as dag:
    create_cluster = CreateClusterOperator()
    job = PySparkOperator('create_mission_report')
    delete_cluster = DeleteClusterOperator()
    create_cluster >> job >> delete_cluster