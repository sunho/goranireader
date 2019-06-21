FROM gorani-base

RUN apk add build-base libffi-dev linux-headers zeromq-dev
RUN pip3.6 install jupyter papermill

COPY ./configs/kernel.json /usr/share/jupyter/kernels/pyspark/kernel.json
COPY ./configs/shell.py /opt/spark/shell.py

RUN mkdir /home/ipython

RUN mkdir -p /root/.ipython/profile_pyspark/startup/
ADD ./configs/profile.py /root/.ipython/profile_pyspark/startup/00-load.py


WORKDIR /home

ADD jobs .
ADD configs/run-notebook.py .
