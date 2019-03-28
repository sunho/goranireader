package main

import (
	"gorani/routes"
	"gorani/servs/authserv"
	"gorani/servs/dataserv"
	"gorani/servs/dbserv"
	"gorani/servs/fileserv"
	"gorani/servs/redserv"

	"github.com/sunho/dim"
)

func main() {
	d := dim.New()
	d.Provide(authserv.Provide, redserv.Provide, dbserv.Provide, fileserv.Provide, dataserv.Provide)
	d.Init("")
	d.Register(routes.RegisterRoutes)
	d.Start(":8081")
}
