package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/servs/authserv"
	"gorani/servs/dbserv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type User struct {
	Auth *authserv.AuthServ `dim:"on"`
	DB   *dbserv.DBServ     `dim:"on"`
}

func (u *User) Register(d *dim.Group) {
	d.POST("/login", u.Login)
	d.RouteFunc("/me", func(d *dim.Group) {
		d.Use(&middles.AuthMiddle{})
		d.GET("", u.GetMe)
	})
}

func (u *User) Login(c echo.Context) error {
	params := struct {
		Username string `json:"username"`
		IdToken  string `json:"id_token"`
	}{}
	if err := c.Bind(&params); err != nil {
		return err
	}
	token, err := u.Auth.Login(params.Username, params.IdToken)
	if err != nil {
		return err
	}

	return c.String(200, token)
}

func (u *User) GetMe(c2 echo.Context) error {
	c := c2.(*models.Context)
	return c.NoContent(200)
}
