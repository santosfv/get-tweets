from airflow.models import DAG
from datetime import datetime, timedelta
from airflow.operators import PythonOperator

import papermill as pm


def execute_notebook(ds, **kwargs):
	pm.execute_notebook(
		kwargs['notebook'],
		'/data/notebook-runs/GetTweets-output.ipynb',
		parameters={'dt': ds},
		kernel_name='spylon-kernel',
		progress_bar=False,
		report_mode=True,
		start_timeout=60
	)

dag = DAG(
    'get_tweets',
    default_args={
        'owner': 'data-engineering',
        'depends_on_past': False,
        'email_on_failure': False,
        'email_on_retry': False,
        'retries': 1,
        'retry_delay': timedelta(minutes=5)
    },
    catchup=False,
    start_date=datetime(2020, 10, 25, 22, 0, 0),
    schedule_interval=None,
    max_active_runs=1)

with dag:
    load_tweets = PythonOperator(
        task_id='load_tweets',
        provide_context=True,
        python_callable=execute_notebook,
        op_kwargs={'notebook': '/notebooks/GetTweets.ipynb'},
        dag=dag,
    )

    data_cleaning = PythonOperator(
        task_id='data_cleaning',
        provide_context=True,
        python_callable=execute_notebook,
        op_kwargs={'notebook': '/notebooks/DataCleaning.ipynb'},
        dag=dag,
    )

    load_tweets >> data_cleaning
