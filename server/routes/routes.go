package routes

import (
	"gorani/middles"
	"github.com/sunho/dim"
)

func RegisterRoutes(g *dim.Group) {
	g.UseRaw(middles.ContextMiddle)
	g.Route("/books", &Books{})
	g.Route("/users", &Users{})
}
