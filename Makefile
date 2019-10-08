deploy-dataserver:
	cd backend/dataserver/pipeline && make build && AIRFLOW_BUCKET=gs://gorani-reader-airflow make deploy

deploy-admin:
	cd frontend/admin && npm run build && firebase deploy --only=hosting

deploy-reader:
	cd frontend/reader && npm run build && npm run deploy

deploy-apiserver:
	cd backend/apiserver 