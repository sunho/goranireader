FROM continuumio/miniconda3

RUN apt-get update && apt-get install make

RUN pip install --upgrade pip && \
    pip install --no-cache-dir metaflow && \
    pip install --no-cache-dir pylint && \
    pip install --no-cache-dir boto3 gorani pandera && \
    conda config --add channels conda-forge && \
    conda config --add channels ksunhokim


WORKDIR /home
ADD . .

