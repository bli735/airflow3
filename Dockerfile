FROM python:3.7-slim

ARG AIRFLOW_USER_HOME=/usr/local/airflow
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

RUN apt-get update && apt-get install -yqq build-essential
RUN pip install apache-airflow[aws]==1.10.12 --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-1.10.12/constraints-3.7.txt"


COPY requirements.txt .
RUN pip install -r requirements.txt


COPY script/entrypoint.sh /entrypoint.sh
COPY src ${AIRFLOW_USER_HOME}/src
COPY dags ${AIRFLOW_USER_HOME}/dags
COPY config/airflow.cfg ${AIRFLOW_USER_HOME}/airflow.cfg


# This fixes permission issues on linux. 
# The airflow user should have the same UID as the user running docker on the host system.
# make build is adjust this value automatically
ARG DOCKER_UID
RUN \
    : "${DOCKER_UID:?Build argument DOCKER_UID needs to be set and non-empty. Use 'make build' to set it automatically.}" \
    && usermod -u ${DOCKER_UID} airflow \
    && find / -path /proc -prune -o -user 50000 -exec chown -h airflow {} \; \
    && echo "Set airflow's uid to ${DOCKER_UID}"


EXPOSE 8080

USER airflow
WORKDIR ${AIRFLOW_USER_HOME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["webserver"]
