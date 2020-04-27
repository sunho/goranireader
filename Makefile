SHELL=/bin/bash
DOCS_GIT="https://github.com/gorani-zoa/gorani-reader-api-docs.git"
REV=$(git rev-parse HEAD | git name-rev --stdin)

setup-common:
	npm install --prefix common/types

setup-python:
	cd backend/dataserver && make create-env

setup-node: setup-common
	npm install --prefix frontend/app
	npm install --prefix backend/apiserver/functions

setup: setup-python setup-node

types:
	cd common/types && ./types.sh

docs:
	cd backend/dataserver && . ./activate.sh && make build-docs
	cd common/types && ./types.sh
	rm -rf /tmp/gorani-docs || true
	mkdir /tmp/gorani-docs
	cp -R backend/dataserver/docs/build/html /tmp/gorani-docs/dataserver
	cp -R common/types/build /tmp/gorani-docs/common
	cp docs-index.html /tmp/gorani-docs/index.html

test-dataserver:
	cd backend/dataserver && . ./activate.sh && make test