package server

import (
	"encoding/json"
	"gorani/service/encserv"
	"gorani/service/redserv"
	"gorani/models"
	"github.com/labstack/echo"
	"github.com/gobuffalo/pop"
)

func (r *Routes) setupUsers(conn *pop.Connection, enc *endserv.EncServ, red *redserv.RedServ) error {
	r.users = &Users {
		conn: conn,
		enc: enc,
		red: red,
	}
	return nil
}

type Users struct {
	conn *pop.Connection
	enc *encserv.EncServ
	red *redserv.RedServ
}

func (u *Users) register(g *echo.Group) {
}

func (u *Users) createRegRequest(c echo.Context) error {
	req := struct{
		Email string `json:"email"`
		Username string `json:"username"`
		Password string `json:"password"`
	}{}
	err := json.NewDecoder(c.Request().Body).Decode(&req)
	if err != nil {
		return err
	}

	u.enc.
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

func (u *Users) request(c echo.Context) error {

}