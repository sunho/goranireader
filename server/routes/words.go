package routes

import (
	"gorani/models"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Words struct {
}

type Uwords struct {
}

func (u *Uwords) Register(d *dim.Group) {
}

func (u *Uwords) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	c.User
}
