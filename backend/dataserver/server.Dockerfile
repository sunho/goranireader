FROM python

ADD ./requirements.txt /root/requirements.txt
RUN pip3 install -r /root/requirements.txt

ADD . /root

CMD /usr/local/bin/uwsgi --http 0.0.0.0:8000 --chdir /root --wsgi-file  /root/server.py --callable __hug_wsgi__
