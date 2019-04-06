set -e

. ./deploy/env.sh

./deploy/ssh.sh "sudo rm -rf $AIRFLOW_HOME/dags"
scp -r "$PWD/dataserver/dags" "$SERVER:$AIRFLOW_HOME/dags"
./deploy/ssh.sh "chmod -R 770 $AIRFLOW_HOME/dags"