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
	g.Use(&middles.ContextMiddle{}, &middles.TxMiddle{}, &middles.ErrorMiddle{})
	g.Route("/book", &Book{})
	g.Route("/shop", &Shop{})
	g.Route("/recommend", &Recommend{})
	g.Route("/memory", &Memory{})
	g.Route("/result", &Result{})
	g.Route("/user", &User{})
	g.Route("/admin", &Admin{})
	g.Route("/word", &Word{})
	g.Route("/evlog", &Evlog{})
	g.Route("/post", &Post{})
	g.Route("/mission", &Mission{})
}
