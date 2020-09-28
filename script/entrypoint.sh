#!/bin/bash


: "${AIRFLOW_HOME:="/usr/local/airflow"}"

export \
  AIRFLOW_HOME \

case "$1" in
  webserver)
    airflow initdb
    airflow scheduler
    fi
    exec airflow webserver
    ;;
  *)
    exec "$@"
    ;;
esac