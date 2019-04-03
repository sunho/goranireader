set -e
. ./deploy/env.sh

./deploy/send-data-src.sh

./deploy/ssh.sh "cd $GORANI_HOME && deploy/local/spark.sh $@"