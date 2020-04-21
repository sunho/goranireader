FROM golang

RUN go get github.com/gocql/gocql
RUN go get github.com/jinzhu/gorm
RUN go get github.com/scylladb/gocqlx
RUN go get github.com/scylladb/gocqlx/qb
RUN go get github.com/jinzhu/gorm/dialects/sqlite

WORKDIR /home
ADD . .
RUN go build -o dicttodata