package main

import (
	"log"
	"gorani/server"
)

func main() {
	s:= server.New("127.0.0.1:8080", newDig())
	log.Fatal(s.Listen())
}
