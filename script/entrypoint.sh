#!/usr/bin/env bash

: "${AIRFLOW_HOME:="/usr/local/airflow"}"
: "${AIRFLOW__CORE__EXECUTOR:=${EXECUTOR:-Sequential}Executor}"

export \
  AIRFLOW_HOME \
  AIRFLOW__CORE__EXECUTOR \


case "$1" in
  webserver)
    airflow initdb
    if [ "$AIRFLOW__CORE__EXECUTOR" = "LocalExecutor" ] || [ "$AIRFLOW__CORE__EXECUTOR" = "SequentialExecutor" ]; then
      airflow scheduler &
    fi
    exec airflow webserver
    ;;
  worker|scheduler)
    sleep 10
    exec airflow "$@"
    ;;
  *)
    exec "$@"
    ;;
esac