FROM tensorflow/tensorflow:latest-gpu-py3-jupyter

RUN apt-get install -y libpq-dev python-dev

RUN pip3 install nltk minio cassandra-driver papermill psycopg2

COPY ./configs/nltk-install.py .

RUN python3 nltk-install.py
