. ./deploy/env.sh

ssh -t "$SERVER" ". /etc/profile; . ~/.profile; $@"