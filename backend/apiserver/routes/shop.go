package routes

import (
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/servs/dbserv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Shop struct {
	DB *dbserv.DBServ
}

func (s *Shop) Register(d *dim.Group) {
	d.GET("/category", s.GetCategory)
	d.Route("/book", &ShopBook{})
}

func (s *Shop) GetCategory(c2 echo.Context) error {
	c := c2.(*models.Context)
	var out []dbmodels.Category
	err := c.Tx.All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}
