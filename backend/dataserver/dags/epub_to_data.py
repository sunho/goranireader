from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta
import os

## Define the DAG object
default_args = {
    'owner': 'gorani-admin',
    'depends_on_past': False,
    'start_date': datetime(2016, 10, 15),
    'retries': 0
}
dag = DAG('epub_to_data', default_args=default_args)

spark = BashOperator(
    task_id='spark',
    bash_command='cd $AIRFLOW_HOME && make ARGS="epubtodata --all" run',
    dag=dag)