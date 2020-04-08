.PHONY: all
all: end


download:
	./run.sh ./download_log.py

pre-process: download
	./run.sh ./preprocess_paginate.py

generate-review: pre-process
	./run.sh ./generate_review.py

daily: generate-review
	echo "complete"

login: 
	aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 926877676119.dkr.ecr.ap-northeast-2.amazonaws.com

deploy:
	docker build -t gorani .
	docker tag gorani:latest 926877676119.dkr.ecr.ap-northeast-2.amazonaws.com/gorani-reader:latest
	docker push 926877676119.dkr.ecr.ap-northeast-2.amazonaws.com/gorani-reader:latest