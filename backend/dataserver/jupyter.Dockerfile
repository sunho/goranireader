FROM gorani-jbase

WORKDIR /home

ADD jobs .
ADD configs/run-notebook.py .
