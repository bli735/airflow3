from airflow import DAG
from airflow.operators import PythonOperator, DummyOperator
from datetime import timedelta, datetime
from get_sensor_data import get_sensor_data

default_args = {
    'owner': 'ubuntu',
    'depends_on_past': False,
    'start_date': datetime(2020, 9, 28),
    'retries': 3,
    'retry_delay': timedelta(seconds = 30)
}

with DAG(
        dag_id = 'purpleair_sensors',
        description = "Request PurpleAir sensor data",
        default_args = default_args,
        schedule_interval = timedelta(minutes = 5),
        catchup = False) as dag:

            t1 = DummyOperator(task_id='dummy_task')   
            t2 = PythonOperator(task_id='purpleair_api', python_callable=get_sensor_data)

            t1 >> t2