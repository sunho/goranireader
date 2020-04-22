FROM continuumio/miniconda3:4.7.12

RUN apt-get update
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_10.x  | bash -
RUN apt-get -y install nodejs
RUN apt-get install make

WORKDIR /home

ADD Makefile .
RUN mkdir -p ./backend/dataserver
ADD backend/dataserver/env.yaml ./backend/dataserver

RUN mkdir -p ./frontend/app
ADD common/types/package.json ./common/types/package.json

RUN mkdir -p ./frontend/app
ADD frontend/app/package.json ./frontend/app/package.json

RUN mkdir -p ./backend/apiserver/functions
ADD backend/apiserver/functions/package.json ./backend/apiserver/functions/packages.json

RUN make setup