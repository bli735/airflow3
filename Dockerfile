FROM python:3.7-slim

# airflow
ARG AIRFLOW_USER_HOME=/usr/local/airflow
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

# python
ENV PYTHONPATH "${PYTHONPATH}:/usr/local/airflow/src"

# update packages, create user airflow, install airflow
RUN apt-get update \
    && apt-get install -yqq build-essential \
    && useradd -ms /bin/bash -d ${AIRFLOW_USER_HOME} airflow
RUN pip install apache-airflow[aws]==1.10.12 --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-1.10.12/constraints-3.7.txt"

# install python dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt


COPY script/entrypoint.sh /entrypoint.sh
COPY src ${AIRFLOW_USER_HOME}/src
COPY dags ${AIRFLOW_USER_HOME}/dags
COPY config/airflow.cfg ${AIRFLOW_USER_HOME}/airflow.cfg


# create data directory to save files
RUN mkdir ${AIRFLOW_USER_HOME}/data


RUN chown -R airflow: ${AIRFLOW_USER_HOME}


EXPOSE 8080


USER airflow
WORKDIR ${AIRFLOW_USER_HOME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["webserver"]
