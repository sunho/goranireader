package server

import (
	"gorani/util"
	"net/http"
	"encoding/json"
	"gorani/service/encserv"
	"gorani/service/redserv"
	"gorani/models"
	"github.com/labstack/echo"
	"github.com/gobuffalo/pop"
)

func (r *Routes) setupUsers(conn *pop.Connection, enc *encserv.EncServ, red *redserv.RedServ) error {
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
	u.registerRegReq(g.Group("regreq"))
}

func (u *Users) createRegRequest(c echo.Context) error {
	params := struct{
		Email string `json:"email"`
		Username string `json:"username"`
		Password string `json:"password"`
	}{}
	err := json.NewDecoder(c.Request().Body).Decode(&params)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err)
	}

	if err = util.ReturnErrIfExists(u.conn, "email", &models.User{Email: params.Email}); err != nil {
		return err
	}

	if err = util.ReturnErrIfExists(u.conn, "username", &models.User{Username: params.Username}); err != nil {
		return err
	}

	hash, err:= u.enc.HashPassword(params.Password)
	if err != nil {
		return err
	}

	req := models.RegRequest{
		Email: params.Email,
		Username: params.Username,
		PasswordHash: hash,
	}

	key, err := u.red.CreateRegRequest(req)
	if err != nil {
		return err
	}

	return c.String(200, key)
}

func (u *Users) registerRegReq(g *echo.Group) {

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
	return c.JSON(200, d)
}