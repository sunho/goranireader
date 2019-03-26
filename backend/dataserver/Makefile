SPARKSUBMIT := ~/spark/bin/spark-submit

.venv:
	if [ ! -e ".venv/bin/activate_this.py" ] ; then virtualenv --clear .venv ; fi

deps: .venv
	. .venv/bin/activate && pip install -U -r ./requirements.txt -t ./miner/libs 
	. .venv/bin/activate && pip install -U -r ./requirements-miner.txt -t ./miner/libs

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

run:
	zip -r ./dist/in.zip ./in
	$(SPARKSUBMIT) --master spark://localhost:7077 --py-files ./dist/main.py,./dist/miner.zip,./dist/common.zip,./dist/in.zip main.py epubtodata --all