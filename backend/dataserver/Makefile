.PHONY: all
all: end


download:
	PYTHONPATH=$PWD python ./cli.py run download_log

load_metadata:
	PYTHONPATH=$PWD python ./cli.py run load_metadata

preprocess: download load_metadata
	PYTHONPATH=$PWD python ./cli.py run preprocess_paginate

prepare_features: preprocess
	PYTHONPATH=$PWD python ./cli.py run prepare_features

predict_vocab: prepare_features
	PYTHONPATH=$PWD python ./cli.py run predict_vocab

generate_stats: predict_vocab
	PYTHONPATH=$PWD python ./cli.py run generate_stats

generate_review: generate_stats
	PYTHONPATH=$PWD python ./cli.py run preprocess_paginate

daily: generate_review
	echo "complete"

login: 
	aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 926877676119.dkr.ecr.ap-northeast-2.amazonaws.com

deploy:
	docker build -t gorani .
	docker tag gorani:latest 926877676119.dkr.ecr.ap-northeast-2.amazonaws.com/gorani-reader:latest
	docker push 926877676119.dkr.ecr.ap-northeast-2.amazonaws.com/gorani-reader:latest