.venv:
	if [ ! -e ".venv/bin/activate_this.py" ] ; then virtualenv --clear .venv --python=python3.6; fi

deps: .venv
	. .venv/bin/activate && pip install -U -r ./requirements.txt
	. .venv/bin/activate && venv-pack -o ./.venv.tar.gz

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

run-spark: .venv build
	zip -r ./dist/in.zip ./in
	. .venv/bin/activate && PYSPARK_PYTHON="./.venv/bin/python" PYSPARK_DRIVER_PYTHON="./.venv/bin/python" $(SPARK_SUBMIT) ${SPARK_ARGS} --py-files ./dist/workercli.py,./dist/gorani.zip --archives ./dist/in.zip,./.venv.tar.gz#.venv workercli.py ${ARGS}

run: .venv
	. .venv/bin/activate && python workercli.py ${ARGS}

