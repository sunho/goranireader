package main

import (
	"gorani/servs/authserv"
	"gorani/routes"
	"gorani/servs/dbserv"
	"gorani/servs/fileserv"
	"gorani/servs/redserv"
	"gorani/servs/wordserv"

	"github.com/sunho/dim"
)

func main() {
	d := dim.New()
	d.Provide(authserv.Provide, redserv.Provide, dbserv.Provide, fileserv.Provide, wordserv.Provide)
	d.Init("")
	d.Register(routes.RegisterRoutes)
	d.Start(":8081")
}
