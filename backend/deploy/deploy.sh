set -e
. ./deploy/env.sh

./deploy/ssh.sh "$GORANI_HOME/deploy/local/stop-all.sh"
./deploy/send.sh
./deploy/ssh.sh "cd $GORANI_HOME && deploy/local/build-api.sh $APISERVER_VOL"
./deploy/ssh.sh "cd $GORANI_HOME && deploy/local/build-spark.sh"
./deploy/ssh.sh "cd $GORANI_HOME && deploy/local/airflow.sh"
./deploy/ssh.sh "$GORANI_HOME/deploy/local/start-all.sh"