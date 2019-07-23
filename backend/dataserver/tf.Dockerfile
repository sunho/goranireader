FROM gorani-tbase

ADD gorani gorani
ADD setup.py setup.py

RUN python3.6 setup.py install

WORKDIR /home

ADD jobs .
ADD configs/run-notebook.py .