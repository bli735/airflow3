#!/usr/bin/env bash


: "${AIRFLOW_HOME:="/usr/local/airflow"}"

export \
  AIRFLOW_HOME \

airflow initdb
airflow scheduler
exec airflow webserver

