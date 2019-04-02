SPARKSUBMIT := ~/spark/bin/spark-submit
.venv:
	if [ ! -e ".venv/bin/activate_this.py" ] ; then virtualenv --clear .venv ; fi

deps: .venv
	. .venv/bin/activate && pip install -U -r ./requirements.txt
	. .venv/bin/activate && venv-pack -o ./dist/.venv.tar.gz

clean: clean-build clean-pyc

clean-build:
	rm -fr dist/

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +


build: clean
	mkdir ./dist
	cp ./workercli.py ./dist
	zip -r ./dist/gorani.zip ./gorani

dev: .venv
	zip -r ./dist/in.zip ./in
	. .venv/bin/activate && PYSPARK_PYTHON="./.venv/bin/python" PYSPARK_DRIVER_PYTHON="./.venv/bin/python" $(SPARKSUBMIT) --master local --py-files ./dist/workercli.py,./dist/gorani.zip --archives ./dist/in.zip,./dist/.venv.tar.gz#.venv workercli.py ${ARGS}

# TODO
run-spark: dev

run: .venv
	. .venv/bin/activate && python workercli.py ${ARGS}

