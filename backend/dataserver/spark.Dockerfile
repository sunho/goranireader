FROM spark-py:spark-docker

RUN apk update && apk add postgresql-dev gcc musl-dev python3-dev libxslt-dev

COPY spark.requirements.txt spark.requirements.txt
RUN pip3.6 install -r spark.requirements.txt

COPY ./configs/nltk-install.py nltk-install.py
RUN python3.6 nltk-install.py
