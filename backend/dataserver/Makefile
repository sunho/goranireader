SPARKSUBMIT := ~/spark/bin/spark-submit
.venv:
	if [ ! -e ".venv/bin/activate_this.py" ] ; then virtualenv --clear .venv ; fi

dev-deps: .venv
	. .venv/bin/activate && pip install -U -r ./requirements.txt
	. .venv/bin/activate && pip install -U -r ./requirements-miner.txt

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
	cp ./main.py ./dist
	zip -r ./dist/miner.zip ./miner
	zip -r ./dist/common.zip ./common

dev: .venv
	zip -r ./dist/in.zip ./in
	. .venv/bin/activate && $(SPARKSUBMIT) --master spark://localhost:7077 --py-files ./dist/main.py,./dist/miner.zip,./dist/common.zip --archives ./dist/in.zip main.py ${ARGS}

# TODO
run: dev 