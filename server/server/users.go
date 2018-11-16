package server

import (
	"gorani/service/redserv"
	"gorani/models"
	"github.com/labstack/echo"
	"github.com/gobuffalo/pop"
)

func (r *Routes) setupUsers(conn *pop.Connection, red *redserv.RedServ) error {
	r.users = &Users {
		conn: conn,
		red: red,
	}
	return nil
}

type Users struct {
	conn *pop.Connection
	red *redserv.RedServ
}

func (u *Users) register(g *echo.Group) {
	g.GET("/", u.getUsers)
}

func (u *Users) getUsers(c echo.Context) error {
	d := []models.User{}
	err := u.conn.Create(&models.User{Username:"test"})
	if err != nil {
		return err 
	}
	err = u.conn.All(&d)
	if err != nil {
		return err
	}
	c.JSON(200, d)
	return nil
}

func (u *Users) 