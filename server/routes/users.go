package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/servs/authserv"
	"gorani/servs/dbserv"
	"gorani/servs/redserv"
	"gorani/utils"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Users struct {
	Auth *authserv.AuthServ `dim:"on"`
	DB   *dbserv.DBServ     `dim:"on"`
	Red  *redserv.RedServ   `dim:"on"`
}

func (u *Users) Register(d *dim.Group) {
	d.POST("/", u.postUser)
	d.POST("/login/", u.login)
	d.RouteFunc("/me", func(d *dim.Group) {
		d.Use(&middles.AuthMiddle{})
		d.GET("/", u.getMe)
	})
}

func (u *Users) postUser(c echo.Context) error {
	params := struct {
		Username string `json:"username"`
		Email    string `json:"email"`
		Password string `json:"password"`
	}{}
	if err := c.Bind(&params); err != nil {
		return err
	}

	hash, err := u.Auth.HashPassword(params.Password)
	if err != nil {
		return err
	}

	user := dbmodels.User{
		Username:     params.Username,
		Email:        params.Email,
		PasswordHash: hash,
	}

	if err = u.DB.Create(&user); err != nil {
		return err
	}

	return c.NoContent(201)
}

func (u *Users) getUsers(c echo.Context) error {
	d := []dbmodels.User{}
	err := u.DB.Create(&dbmodels.User{Username: "test"})
	if err != nil {
		return err
	}

	err = u.DB.All(&d)
	if err != nil {
		return err
	}
	return c.JSON(200, d)
}

func (u *Users) login(c echo.Context) error {
	params := struct {
		Username string `json:"username"`
		Password string `json:"password"`
	}{}
	if err := c.Bind(&params); err != nil {
		return err
	}
	token, err := u.Auth.Login(params.Username, params.Password)
	if err != nil {
		return err
	}

	return c.JSON(200, utils.M{
		"token": token,
	})
}

func (u *Users) getMe(c2 echo.Context) error {
	c := c2.(*models.Context)
	return c.NoContent(200)
}
