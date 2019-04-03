set -e

. ./deploy/env.sh

./deploy/ssh.sh "rm $GORANI_HOME$@"
scp "$PWD$@" "$SERVER:$GORANI_HOME$@"
./deploy/ssh.sh "chmod 770 $GORANI_HOME$@"