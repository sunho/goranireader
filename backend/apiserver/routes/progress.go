package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/servs/dbserv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Progress struct {
}

func (p *Progress) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.Route("/sens", &ProgressSens{})
}

type ProgressSens struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (p *ProgressSens) Register(d *dim.Group) {
	d.GET("", p.List)
	d.RouteFunc("/:bookid", func(d *dim.Group) {
		d.PUT("", p.Put)
		d.DELETE("", p.Delete)
	}, &middles.BookParamMiddle{})
}

func (p *ProgressSens) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	var out []dbmodels.SensProgress
	err := c.Tx.Where("user_id = ?", c.User.ID).All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (p *ProgressSens) Put(c2 echo.Context) error {
	c := c2.(*models.Context)
	var pro dbmodels.SensProgress
	if err := c.Bind(&pro); err != nil {
		return err
	}
	pro.UserID = c.User.ID
	pro.BookID = c.BookParam.ID
	err := p.DB.Upsert(c.Tx, &pro)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (p *ProgressSens) Delete(c2 echo.Context) error {
	c := c2.(*models.Context)

	var pro dbmodels.SensProgress
	err := c.Tx.Where("user_id = ? and book_id = ?", c.User.ID, c.BookParam.ID).First(&pro)
	if err != nil {
		return err
	}
	err = c.Tx.Destroy(&pro)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}
