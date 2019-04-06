set -e

. ./deploy/env.sh

./deploy/ssh.sh "sudo rm -rf $GORANI_HOME$@"
scp -r "$PWD$@" "$SERVER:$GORANI_HOME$@"
./deploy/ssh.sh "chmod -R 770 $GORANI_HOME$@"