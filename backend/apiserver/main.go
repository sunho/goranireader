//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package main

import (
	"gorani/routes"
	"gorani/servs/authserv"
	"gorani/servs/dataserv"
	"gorani/servs/dbserv"
	"gorani/servs/fileserv"

	"github.com/sunho/dim"
)

func main() {
	d := dim.New()
	d.Provide(authserv.Provide, dbserv.Provide, fileserv.Provide, dataserv.Provide)
	d.Init("")
	d.Register(routes.RegisterRoutes)
	d.Start(":5353")
}
