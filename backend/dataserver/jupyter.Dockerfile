FROM gorani-jbase

ADD gorani gorani
ADD setup.py setup.py


WORKDIR /home

ADD jobs .
ADD configs/run-notebook.py .
