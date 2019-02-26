package main

import (
	"gorani/servs/fileserv"
	"gorani/servs/dbserv"
	"gorani/servs/redserv"
	"github.com/sunho/dim"
	"gorani/routes"
)

func main() {
	d := dim.New()
	d.Provide(redserv.Provide,dbserv.Provide,fileserv.Provide)
	d.Init("")
	d.Register(routes.RegisterRoutes)
	d.Start(":8081")
}

