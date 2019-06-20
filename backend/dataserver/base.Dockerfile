FROM gorani-spark

COPY ./configs/spark-cassandra-connector_2.11-2.3.2.jar /etc/spark-cassandra-connector_2.11-2.3.2.jar
COPY ./configs/spark-sql-kafka-0-10_2.11-2.4.0.jar /etc/spark-sql-kafka-0-10_2.11-2.4.0.jar
COPY ./configs/kafka-clients-0.10.1.0.jar /etc/kafka-clients-0.10.1.0.jar
COPY ./configs/jsr166e-1.1.0.jar /etc/jsr166e-1.1.0.jar

ADD gorani gorani
ADD setup.py setup.py

RUN python3.6 setup.py install