//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/middles"

	"github.com/sunho/dim"
)

func RegisterRoutes(g *dim.Group) {
	g.Use(&middles.LoggerMiddle{})
	g.Use(&middles.ErrorMiddle{})
	g.Route("/book", &Book{})
	g.Route("/memory", &Memory{})
	g.Route("/user", &User{})
	g.Route("/admin", &Admin{})
	g.Route("/evlog", &Evlog{})
	g.Route("/mission", &Mission{})
}
