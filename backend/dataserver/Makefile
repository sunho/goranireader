KUBE_MASTER:=k8s://https://183.99.225.238:6443
SPARK_SUBMIT:=$(SPARK_HOME)/bin/spark-submit

build-spark: 
	docker build -t gorani-spark -f spark.Dockerfile .
build-base: 
	docker build -t gorani-base -f base.Dockerfile .
build-jbase: 
	docker build -t gorani-jbase -f jbase.Dockerfile .
build-stream:
	docker build -t ksunhokim/gorani-stream:v$(VER) -f stream.Dockerfile . && docker push ksunhokim/gorani-stream:v$(VER)
build-migrate:
	docker build -t ksunhokim/gorani-migrate:v$(VER) -f migrate.Dockerfile . && docker push ksunhokim/gorani-migrate:v$(VER)
build-jupyter:
	docker build -t ksunhokim/gorani-jupyter:v$(VER) -f jupyter.Dockerfile . && docker push ksunhokim/gorani-jupyter:v$(VER)
build-tbase:
	docker build -t gorani-tbase -f tbase.Dockerfile .
build-tf:
	docker build -t ksunhokim/gorani-tf:v$(VER) -f tf.Dockerfile . && docker push ksunhokim/gorani-tf:v$(VER)
run-stream: 
	$(SPARK_SUBMIT) --master $(KUBE_MASTER) \
		--deploy-mode cluster \
		--name stream \
		--conf spark.executor.instances=1 \
		--conf spark.kubernetes.container.image=ksunhokim/gorani-stream:v$(VER) \
		--conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
		--conf spark.kubernetes.driver.pod.name=stream \
		--conf spark.cassandra.connection.host=cassandra \
		--conf spark.redis.host=agile-ostrich-redis-master \
		--conf spark.kubernetes.pyspark.pythonVersion=3 \
		local:///etc/stream.py

