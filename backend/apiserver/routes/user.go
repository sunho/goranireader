//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/servs/authserv"
	"strconv"

	"github.com/sunho/webf/servs/dbserv"

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

func (u *User) Login(c *models.Context) error {
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

func (u *User) GetMe(c *models.Context) error {
	return c.NoContent(200)
}

func (u *User) Get(c *models.Context) error {
	id, err := strconv.Atoi(c.Param("userid"))
	if err != nil {
		return err
	}
	var user models.User
	err = c.Tx.Where("id = ?", id).First(&user)
	if err != nil {
		return err
	}
	return c.JSON(200, user)
}
