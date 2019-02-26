package routes

import (
	"gorani/utils"
	"gorani/servs/authserv"
	"gorani/servs/dbserv"
	"gorani/models"
	"gorani/servs/redserv"

	"github.com/sunho/dim"
	"github.com/labstack/echo"
)

type Users struct {
	Auth *authserv.AuthServ `dim:"on"`
	DB *dbserv.DBServ `dim:"on"`
	Red  *redserv.RedServ `dim:"on"`
}

func (u *Users) Register(g *dim.Group) {
	g.POST("/", u.postUser)
	g.POST("/login/", u.login)
	g.GET("/me/", u.getMe)
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

	user := models.User {
		Username: params.Username,
		Email: params.Email,
		PasswordHash: hash,
	}

	if err = u.DB.Create(&user); err != nil {
		return err
	}

	return c.NoContent(201)
}

func (u *Users) getUsers(c echo.Context) error {
	d := []models.User{}
	err := u.DB.Create(&models.User{Username: "test"})
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
}