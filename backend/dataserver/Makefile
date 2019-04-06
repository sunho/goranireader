VENV=/gorani/venv

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
	cp ./workercli.py ./dist
	zip -r ./dist/gorani.zip ./gorani

run-spark: build
	zip -r ./dist/in.zip ./in
	. $(VENV)/bin/activate && $(SPARK_SUBMIT) ${SPARK_ARGS} --py-files ./dist/workercli.py,./dist/gorani.zip --archives ./dist/in.zip#in workercli.py ${ARGS}

run:
	. $(VENV)/bin/activate && python workercli.py ${ARGS}

