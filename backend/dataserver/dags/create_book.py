from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from datetime import datetime, timedelta
import os

default_args = {
    'owner': 'gorani-admin',
    'start_date': datetime(2016, 10, 15)
}

with DAG('create_book', default_args=default_args, schedule_interval=None) as dag:
    clean = BashOperator(
        task_id='clean',
        bash_command='cd $AIRFLOW_HOME && make ARGS="deletebook --id {{ dag_run.conf["id"] }}" run'
    )

    spark = BashOperator(
        task_id='spark',
        bash_command='cd $AIRFLOW_HOME && make ARGS="sparkjob createbook --id {{ dag_run.conf["id"] }}" run-spark')

    clean >> spark
