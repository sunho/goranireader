package main

import (
	"gorani/service/dbserv"
	"gorani/service/encserv"
	"gorani/service/redserv"
	"github.com/sunho/dim"
	"gorani/routes"
)

func main() {
	d := dim.New()
	d.Provide(redserv.Provide)
	d.Provide(dbserv.Provide)
	d.Provide(encserv.Provide)
	d.Init("")
	d.Register(routes.RegisterRoutes)
	d.Start(":8080")
}
