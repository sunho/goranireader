set -e

. ./deploy/env.sh

./deploy/ssh.sh "sudo rm -f $GORANI_HOME$@"
scp "$PWD$@" "$SERVER:$GORANI_HOME$@"
./deploy/ssh.sh "chmod 770 $GORANI_HOME$@"