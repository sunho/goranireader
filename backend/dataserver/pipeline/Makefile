PROJECT=gorani-reader-249509
CLUSTER=cluster4
BUCKET=gorani-reader-airflow
AIRFLOW_BUCKET=gs://${BUCKET}
build: 
	rm -rf ./dist
	mkdir ./dist
	zip -r ./dist/gorani.zip ./gorani
	rsync -r --delete gorani/ functions/gorani/
	rsync -r --delete gorani/ dags/gorani/

deploy:
	gsutil cp ./dist/gorani.zip ${AIRFLOW_BUCKET}
	gsutil rsync -r -d ./jobs ${AIRFLOW_BUCKET}/spark-jobs
	gsutil rsync -r -d ./dags ${AIRFLOW_BUCKET}/dags

run:
	gcloud dataproc jobs submit pyspark 'gs://${BUCKET}/spark-jobs/${JOB}' \
		--cluster ${CLUSTER} \
		--py-files='gs://${BUCKET}/gorani.zip'\
		--project=${PROJECT} \
        --files='gs://${BUCKET}/key.json'\
		--region='asia-northeast2'
create:
	gcloud beta dataproc clusters create ${CLUSTER} \
		--image-version=preview \
		--project=${PROJECT} \
        --num-masters=1 \
		--num-workers=0 \
        --metadata=PIP_PACKAGES='firebase-admin seaborn nltk iso8601 reportng gcloud google-api-python-client==1.7.12 httplib2==0.17.0 pyarrow==0.13.0' \
        --initialization-actions='gs://dataproc-initialization-actions/python/pip-install.sh' \
        --master-machine-type="n1-highcpu-16" \
        --master-boot-disk-type="pd-ssd" \
        --master-boot-disk-size=50 \
        --region='asia-northeast2' \
		--enable-component-gateway
start: 
	gcloud compute instances stop ${CLUSTER}

stop: 
	gcloud compute instances stop ${CLUSTER}



func:
	cd functions && gcloud functions deploy due_check --runtime python37 --trigger-topic due_check
