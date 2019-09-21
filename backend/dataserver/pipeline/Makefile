build: 
	rm -rf ./dist
	mkdir ./dist
	zip -r ./dist/gorani.zip ./gorani
	rsync -r --delete gorani/ functions/gorani/
	rsync -r --delete gorani/ dags/gorani/

deploy:
	gsutil cp ./dist/gorani.zip ${AIRFLOW_BUCKET}
	gsutil cp ./init.sh ${AIRFLOW_BUCKET}
	gsutil rsync -r -d ./jobs ${AIRFLOW_BUCKET}/spark-jobs
	gsutil rsync -r -d ./dags ${AIRFLOW_BUCKET}/dags

func:
	cd functions && gcloud functions deploy due_check --runtime python37 --trigger-topic due_check