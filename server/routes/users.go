package routes

import (
	"gorani/service/dbserv"
	"encoding/json"
	"gorani/models"
	"gorani/service/encserv"
	"gorani/service/redserv"
	"net/http"

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
	g.RouteFunc("/req", u.registerRegReq)
}

func (u *Users) registerRegReq(g *dim.Group) {
	g.POST("/", u.createRegReq)
}

func (u *Users) createRegReq(c echo.Context) error {
	params := struct {
		Email    string `json:"email"`
		Username string `json:"username"`
		Password string `json:"password"`
	}{}
	err := json.NewDecoder(c.Request().Body).Decode(&params)
	if err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err)
	}

	if err = u.DB.ReturnErrIfExists("email", &models.User{Email: params.Email}); err != nil {
		return err
	}

	if err = u.DB.ReturnErrIfExists("username", &models.User{Username: params.Username}); err != nil {
		return err
	}

	hash, err := u.Enc.HashPassword(params.Password)
	if err != nil {
		return err
	}

	req := models.RegRequest{
		Email:        params.Email,
		Username:     params.Username,
		PasswordHash: hash,
	}

	key, err := u.Red.CreateRegRequest(req)
	if err != nil {
		return err
	}

	return c.String(200, key)
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
