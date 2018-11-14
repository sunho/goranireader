package server

import (
	"github.com/labstack/echo"
	"go.uber.org/dig"
)

type Routes struct {
	users Route
}

type Route interface {
	register(g *echo.Group)
}

func (r *Routes) setup(c *dig.Container) {
	c.Invoke(r.setupUsers)
}

func (r *Routes) register(e *echo.Echo) {
	r.users.register(e.Group("/users"))
}
