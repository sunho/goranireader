DOCS_GIT="https://github.com/gorani-zoa/gorani-reader-api-docs.git"
REV=$(git rev-parse HEAD | git name-rev --stdin)

setup:
	cd backend/dataserver && make create-env
	npm install --prefix common/types
	npm install --prefix frontend/app
	npm install --prefix backend/apiserver/functions

types:
	cd common/types && ./types.sh

docs:
	cd backend/dataserver && . ./activate.sh && make build-docs
	cd common/types && ./types.sh
	rm -rf /tmp/gorani-docs || true
	mkdir /tmp/gorani-docs
	cp -R backend/dataserver/docs/build/html /tmp/gorani-docs/dataserver
	cp -R common/types/build /tmp/gorani-docs/common