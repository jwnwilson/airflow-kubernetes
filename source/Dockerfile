FROM --platform=amd64 apache/airflow:2.6.2-python3.9

USER root
RUN apt-get update && apt-get install -y gcc python3-dev

USER airflow

# Copy poetry.lock* so dependencies only get rebuilt if they are changed
COPY ./pyproject.toml ./poetry.lock* ./

# Install dependencies in virtual env that can be activated by tasks
ENV VIRTUAL_ENV=/home/airflow/venv
# Install Poetry skip virtual env in docker as unneeded
RUN pip install poetry==1.3.1 && python -m venv $VIRTUAL_ENV 
RUN source /home/airflow/venv/bin/activate && \
    poetry install

COPY --chown=airflow:root dags /opt/airflow/dags
COPY --chown=airflow:root src /opt/airflow/src

ENV PYTHONPATH=$PYTHONPATH:/opt/airflow/src
