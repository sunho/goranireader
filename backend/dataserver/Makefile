.PHONY: all
all: end

trainml: prepare_features
	PYTHONPATH=${PWD} python ./cli.py run ml/train_models

deployml: trainml
	PYTHONPATH=${PWD} python ./cli.py run ml/deploy_model

predict_vocab: prepare_features
	PYTHONPATH=${PWD} python ./cli.py run predict_vocab

download:
	PYTHONPATH=${PWD} python ./cli.py run download_log

load_metadata:
	PYTHONPATH=${PWD} python ./cli.py run load_metadata

preprocess: download load_metadata
	PYTHONPATH=${PWD} python ./cli.py run preprocess_paginate

prepare_features: preprocess
	PYTHONPATH=${PWD} python ./cli.py run prepare_features

generate_stats: predict_vocab
	PYTHONPATH=${PWD} python ./cli.py run generate_stats

generate_review: generate_stats
	PYTHONPATH=${PWD} python ./cli.py run generate_review

daily: generate_review
	echo "complete"

login: 
	aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 926877676119.dkr.ecr.ap-northeast-2.amazonaws.com

deploy:
	docker build -t gorani .
	docker tag gorani:latest 926877676119.dkr.ecr.ap-northeast-2.amazonaws.com/gorani-reader:latest
	docker push 926877676119.dkr.ecr.ap-northeast-2.amazonaws.com/gorani-reader:latest
	