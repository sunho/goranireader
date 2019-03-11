package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/servs/dbserv"
	"gorani/servs/fileserv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Books struct {
	File *fileserv.FileServ `dim:"on"`
	DB   *dbserv.DBServ     `dim:"on"`
}

func (b *Books) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("", b.List)
	d.GET("", b.)
	d.RouteFunc("/:bookid", func(d *dim.Group) {

	}, &middles.BookParamMiddle{}, &middles.BookOfUserMiddle{})
}

func (b *Books) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	books, err := b.DB.GetBooksOfUser(c.Tx, &c.User)
	if err != nil {
		return err
	}
	return c.JSON(200, books)
}

func (b *Books) 
