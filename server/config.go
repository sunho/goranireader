package main

import (
	"go.uber.org/dig"
	"github.com/gobuffalo/pop"
)

func provideConn() (*pop.Connection, error) {
	return pop.Connect("development")
}

func newDig() *dig.Container {
	c := dig.New()
	c.Provide(provideConn)
	return c
}