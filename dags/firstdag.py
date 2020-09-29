from airflow import DAG
from airflow.operators import PythonOperator
from datetime import timedelta, datetime
from src.get_sensor_data import get_sensor_data

default_args = {
    'owner': 'ubuntu',
    'depends_on_past': False,
    'start_date': datetime(2020, 9, 22),
    'retries': 3,
    'retry_delay': timedelta(seconds = 30)
}

with DAG(
        dag_id = 'purpleair_sensors',
        description = "Request PurpleAir sensor data",
        default_args = default_args,
        schedule_interval = timedelta(minutes = 5),
        catchup = False) as dag:
        
    t1 = PythonOperator(get_sensor_data)