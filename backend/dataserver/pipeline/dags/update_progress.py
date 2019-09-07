from datetime import datetime
from airflow import DAG
from operators import PySparkOperator
from consts import PROJECT
args = {
    'start_date': datetime(2019, 9, 7),
    'depends_on_past': False,
    'owner': 'airflow',
    'project_id': PROJECT
}
with DAG('update_progress', default_args=args) as dag:
    job = PySparkOperator('update_progress')
