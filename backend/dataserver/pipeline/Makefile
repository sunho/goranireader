build: 
	rm -rf ./dist
	mkdir ./dist
	zip -r ./dist/gorani.zip ./gorani

deploy:
	gsutil cp ./dist/gorani.zip ${AIRFLOW_BUCKET}
	gsutil rsync -r -d ./jobs ${AIRFLOW_BUCKET}/spark-jobs
