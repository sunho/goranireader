FROM gorani-base

RUN apk add build-base libffi-dev linux-headers zeromq-dev
RUN pip3.6 install jupyter papermill
RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk --update add --no-cache \ 
    lapack-dev \ 
    freetype-dev
RUN apk add --no-cache --virtual .build-deps \
    gfortran \
    musl-dev \
    g++
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h

RUN pip3.6 install seaborn

RUN python3.6 setup.py install

COPY ./configs/kernel.json /usr/share/jupyter/kernels/pyspark/kernel.json
COPY ./configs/shell.py /opt/spark/shell.py

RUN mkdir /home/ipython

RUN mkdir -p /root/.ipython/profile_pyspark/startup/
ADD ./configs/profile.py /root/.ipython/profile_pyspark/startup/00-load.py