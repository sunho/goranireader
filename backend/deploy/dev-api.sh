set -e
. ./deploy/env.sh

./deploy/send-api-src.sh
./deploy/ssh.sh "sudo systemctl stop apiserver"
./deploy/ssh.sh "cd $GORANI_HOME && deploy/local/build-api.sh $APISERVER_VOL"
./deploy/ssh.sh "sudo systemctl start apiserver"