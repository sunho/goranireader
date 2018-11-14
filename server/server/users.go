package server

import (
	"github.com/labstack/echo"
	"github.com/gobuffalo/pop"
)

func (r *Routes) setupUsers(conn *pop.Connection) error {
	r.users = &Users {
		conn: conn,
	}
	return nil
}

type Users struct {
	conn *pop.Connection
}

func (u *Users) register(g *echo.Group) {
	g.GET("/", u.getUsers)
}

func (u *Users) getUsers(c echo.Context) error {
	c.String(200, "hello")
	return nil
}