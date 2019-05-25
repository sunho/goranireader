VENV=/gorani/venv
SPARK_SUBMIT=/etc/spark/bin/spark-submit
SPARK_ARGS=--executor-memory 1G --total-executor-cores 1

deps:
	pip install -U -r ./requirements.txt

clean: clean-build clean-pyc

clean-build:
	sudo rm -fr dist/

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

build: clean
	mkdir ./dist
	cp ./stream.py ./dist
	zip -r ./dist/gorani.zip ./gorani

run-stream: build
	zip -r ./dist/in.zip ./in
	. $(VENV)/bin/activate && $(SPARK_SUBMIT) $(SPARK_ARGS) --py-files ./dist/stream.py,./dist/gorani.zip --archives ./dist/in.zip#in stream.py
