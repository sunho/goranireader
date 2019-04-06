. ./deploy/env.sh

./deploy/send.sh /dataserver/gorani
./deploy/send.sh /dataserver/migrations
./deploy/send.sh /dataserver/dags
./deploy/send-file.sh /dataserver/Makefile
./deploy/send-file.sh /dataserver/workercli.py
./deploy/send-file.sh /dataserver/server.py