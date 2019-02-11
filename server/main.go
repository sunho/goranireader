package main

import (
	"gorani/services/fileserv"
	"gorani/services/dbserv"
	"gorani/services/encserv"
	"gorani/services/redserv"
	"github.com/sunho/dim"
	"gorani/routes"
)

func main() {
	d := dim.New()
	d.Provide(redserv.Provide,dbserv.Provide,encserv.Provide,fileserv.Provide)
	d.Init("")
	d.Register(routes.RegisterRoutes)
	d.Start(":8081")
}

