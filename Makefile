setup:
	npm install --prefix common/types
	npm install --prefix frontend/app
	npm install --prefix backend/apiserver/functions
	conda create -f backend/dataserver/env.yaml

types:
	cd common/types && ./types.sh