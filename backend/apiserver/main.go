//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package main

import (
	"gorani/routes"
	"gorani/servs/authserv"
	"gorani/servs/dataserv"
	"gorani/servs/googleserv"

	"github.com/sunho/dim"
)

func main() {
	w := webf.New("gorani")
	w.Use(
		features.FeatureDBServ(features.DBServDialectPostgresql),
		features.FeatureS3Serv(),
	)
	w.Provide(googleserv.Provide, authserv.Provide, dataserv.Provide)
	w.Register(routes.RegisterRoutes)
	w.Start()
}
