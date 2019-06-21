FROM gorani-spark

COPY ./configs/spark-cassandra-connector_2.11-2.3.2.jar /opt/spark/jars/spark-cassandra-connector_2.11-2.3.2.jar
COPY ./configs/spark-sql-kafka-0-10_2.11-2.4.0.jar /opt/spark/jars/spark-sql-kafka-0-10_2.11-2.4.0.jar
COPY ./configs/kafka-clients-2.0.0.jar /opt/spark/jars/kafka-clients-2.0.0.jar
COPY ./configs/jsr166e-1.1.0.jar /opt/spark/jars/jsr166e-1.1.0.jar

ADD gorani gorani
ADD setup.py setup.py

RUN python3.6 setup.py install