FROM golang:1.12

RUN go get -u github.com/gobuffalo/packr/v2/packr2

WORKDIR /gorani

ADD . .

RUN GO111MODULE=on packr2

RUN GO111MODULE=on go install

WORKDIR /root

CMD ["gorani"]
