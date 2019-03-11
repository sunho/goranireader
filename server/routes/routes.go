package routes

import (
	"gorani/middles"
	"github.com/sunho/dim"
)

func RegisterRoutes(g *dim.Group) {
	g.Use(&middles.ContextMiddle{}, &middles.TxMiddle{})
	g.Route("/books", &Books{})
	g.Route("/users", &Users{})
}
