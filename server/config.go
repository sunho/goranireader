package main

import (
	"go.uber.org/dig"
	"gorani/service/redserv"
	"github.com/gobuffalo/pop"
)

func provideConn() (*pop.Connection, error) {
	return pop.Connect("development")
}

func provideRedServ() (*redserv.RedServ, error) {
	return redserv.New("localhost:6379")
}

func newDig() *dig.Container {
	c := dig.New()
	c.Provide(provideConn)
	c.Provide(provideRedServ)
	return c
}