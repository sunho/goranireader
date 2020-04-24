#!/bin/bash
set -o pipefail
set -e

APISERVER_SRC="../../backend/apiserver/functions/src"
APP_SRC="../../frontend/app/src"
DARASERVER_SRC="../../backend/dataserver/dataserver"


rm -r "$APISERVER_SRC/commonmodels" || true
mkdir "$APISERVER_SRC/commonmodels"

rm -r "$APP_SRC/commonmodels" || true
mkdir "$APP_SRC/commonmodels"

rm -r "$DARASERVER_SRC/commonmodels" || true
mkdir "$DARASERVER_SRC/commonmodels"

for i in ./src/*.ts; do
  name=`basename ${i%.*}`
  
  npx quicktype $i -o "$APISERVER_SRC/commonmodels/$name.ts"
  npx quicktype $i -o "$APP_SRC/commonmodels/$name.ts"
  npx quicktype $i -o "$DARASERVER_SRC/commonmodels/$name.py"
done

npx typedoc ./src --out build