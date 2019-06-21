FROM gorani-base

ADD gorani gorani
ADD setup.py setup.py

RUN python3.6 setup.py install

ADD stream.py /etc/stream.py

