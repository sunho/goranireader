//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/servs/authserv"
	"gorani/servs/dbserv"
	"strconv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type User struct {
	Auth *authserv.AuthServ `dim:"on"`
	DB   *dbserv.DBServ     `dim:"on"`
}

func (u *User) Register(d *dim.Group) {
	d.POST("/login", u.Login)
	d.GET("/:userid", u.Get)
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

func (u *User) Get(c2 echo.Context) error {
	c := c2.(*models.Context)
	id, err := strconv.Atoi(c.Param("userid"))
	if err != nil {
		return err
	}
	var user dbmodels.User
	err = c.Tx.Where("id = ?", id).First(&user)
	if err != nil {
		return err
	}
	return c.JSON(200, user)
}
