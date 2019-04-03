set -e
(cd apiserver && go build)
rm -rf "$1/migrations"
cp -r apiserver/migrations "$1/migrations"