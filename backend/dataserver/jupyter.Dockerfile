FROM gorani-base

RUN apk add build-base libffi-dev linux-headers zeromq-dev
RUN pip3.6 install jupyter papermill

COPY ./configs/kernel.json /usr/share/jupyter/kernels/pyspark/kernel.json
COPY ./configs/run.sh /opt/spark/run.sh
COPY ./configs/shell.py /opt/spark/shell.py

WORKDIR /home

ADD jobs .
ADD configs/run-notebook.py .
