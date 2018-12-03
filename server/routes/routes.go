package routes

import "github.com/sunho/dim"

func RegisterRoutes(g *dim.Group) {
	g.Route("/users", &Users{})
}
