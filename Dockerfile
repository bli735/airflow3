FROM python:3.7-slim

ARG AIRFLOW_USER_HOME=/usr/local/airflow
ENV $AIRFLOW_HOME = ${AIRFLOW_USER_HOME}

RUN apt-get update && apt-get install -yqq build-essential
RUN pip install apache-airflow[aws]==1.10.12 --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-1.10.12/constraints-3.7.txt"


COPY requirements.txt .
RUN pip install -r requirements.txt


COPY script/entrypoint.sh /entrypoint.sh
COPY src ${AIRFLOW_USER_HOME}/src
COPY dags ${AIRFLOW_USER_HOME}/dags


EXPOSE 8080


WORKDIR ${AIRFLOW_USER_HOME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["webserver"]
