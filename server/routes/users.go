package routes

import (
	"gorani/services/dbserv"
	"gorani/models"
	"gorani/services/encserv"
	"gorani/services/redserv"

	"github.com/sunho/dim"
	"github.com/labstack/echo"
)

type Users struct {
	DB *dbserv.DBServ `dim:"on"`
	Enc  *encserv.EncServ `dim:"on"`
	Red  *redserv.RedServ `dim:"on"`
}

func (u *Users) Register(g *dim.Group) {
	g.GET("/", u.getUsers)
	g.POST("/", u.postUser)
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

	hash, err := u.Enc.HashPassword(params.Password)
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
