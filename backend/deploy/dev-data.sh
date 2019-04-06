set -e
. ./deploy/env.sh

./deploy/ssh.sh "sudo systemctl stop dataserver"
./deploy/send-data-src.sh
./deploy/ssh.sh "sudo systemctl start dataserver"