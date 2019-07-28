//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package main

import (
	"gorani/models"
	"gorani/routes"
	"gorani/servs/authserv"
	"gorani/servs/dataserv"
	"gorani/servs/googleserv"

	"github.com/gobuffalo/packr/v2"
	"github.com/sunho/webf/servs/dbserv"

	"github.com/sunho/webf"
	"github.com/sunho/webf/features"
)

func main() {
	w := webf.New("gorani")
	w.Use(
		features.FeatureMiddles(models.NewContext),
		features.FeatureDBServ(features.DBServDialectPostgresql),
		features.FeatureS3Serv(),
	)
	dbserv.Box = packr.New("migrations", "./migrations")
	w.Provide(googleserv.Provide, authserv.Provide, dataserv.Provide)
	w.Register(routes.RegisterRoutes)
	w.Start()
}
