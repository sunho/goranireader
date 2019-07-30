//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/middles"
	"net/http"

	"github.com/labstack/echo/middleware"
	"github.com/sunho/dim"
)

func RegisterRoutes(g *dim.Group) {
	g.Use(&middles.LoggerMiddle{})
	g.Use(&middles.ErrorMiddle{})
	// TODO remove
	g.Group.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{http.MethodGet, http.MethodPut, http.MethodPost, http.MethodDelete},
	}))
	g.Route("/book", &Book{})
	g.Route("/memory", &Memory{})
	g.Route("/user", &User{})
	g.Route("/admin", &Admin{})
	g.Route("/evlog", &Evlog{})
	g.Route("/mission", &Mission{})
}
