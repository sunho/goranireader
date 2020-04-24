.PHONY: all
all: end

download:
	PYTHONPATH=${PWD} python ./cli.py run download

load_metadata:
	PYTHONPATH=${PWD} python ./cli.py run load_metadata

preprocess:
	PYTHONPATH=${PWD} python ./cli.py run preprocess_paginate

prepare_features: preprocess
	PYTHONPATH=${PWD} python ./cli.py run prepare_features

trainml: prepare_features
	PYTHONPATH=${PWD} python ./cli.py run ml/train_models

deployml: trainml
	PYTHONPATH=${PWD} python ./cli.py run ml/deploy_model

predict_vocab: prepare_features
	PYTHONPATH=${PWD} python ./cli.py run predict_vocab

generate_stats: predict_vocab
	PYTHONPATH=${PWD} python ./cli.py run generate_stats

generate_review: generate_stats
	PYTHONPATH=${PWD} python ./cli.py run generate_review

activate:
	conda activate gorani

update-env:
	conda env update -f env.yaml --prune

create-env:
	conda env create -f env.yaml

build-docs:
	cd docs && make html