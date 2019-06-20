FROM gorani-base

RUN apk add build-base libffi-dev linux-headers zeromq-dev
RUN pip3.6 install jupyter papermill

COPY configs/kernel.json /usr/share/jupyter/kernels/pyspark/kernel.json
COPY configs/pyspark/shell.py /opt/spark/python/pyspark/shell.py

WORKDIR /home

ADD jobs .
ADD configs/run-notebook.py .
