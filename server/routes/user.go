package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/servs/authserv"
	"gorani/servs/dbserv"
	"gorani/servs/redserv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type User struct {
	Auth *authserv.AuthServ `dim:"on"`
	DB   *dbserv.DBServ     `dim:"on"`
	Red  *redserv.RedServ   `dim:"on"`
}

func (u *User) Register(d *dim.Group) {
	d.POST("", u.PostUser)
	d.POST("/login", u.Login)
	d.RouteFunc("/me", func(d *dim.Group) {
		d.Use(&middles.AuthMiddle{})
		d.GET("", u.GetMe)
	})
}

func (u *User) PostUser(c2 echo.Context) error {
	c := c2.(*models.Context)
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

	if err = c.Tx.Eager().Create(&user); err != nil {
		return err
	}

	err = c.Tx.Create(&dbmodels.RecommendInfo{
		UserID: user.ID,
	})
	if err != nil {
		return err
	}

	return c.NoContent(201)
}

func (u *User) Login(c echo.Context) error {
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

	return c.String(200, token)
}

func (u *User) GetMe(c2 echo.Context) error {
	c := c2.(*models.Context)
	return c.NoContent(200)
}
