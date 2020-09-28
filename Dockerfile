FROM python:3.7-slim

RUN sudo apt-get install -yqq --no-install-recommends \
        freetds-bin \
        krb5-user \
        ldap-utils \
        libffi6 \
        libsasl2-2 \
        libsasl2-modules \
        libssl1.1 \
        locales  \
        lsb-release \
        sasl2-bin \
        sqlite3 \
        unixodbc

RUN pip install apache-airflow[aws]==1.10.12

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY src src
COPY dags airflow/dags

EXPOSE 8080

airflow initdb
airflow webserver
airflow scheduler


