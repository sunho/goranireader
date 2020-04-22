setup:
	conda env update -f backend/dataserver/env.yaml
	npm install --prefix common/types
	npm install --prefix frontend/app
	npm install --prefix backend/apiserver/functions

types:
	cd common/types && ./types.sh

build-docs:
	