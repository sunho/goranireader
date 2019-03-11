package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/servs/dbserv"
	"gorani/servs/fileserv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Book struct {
	File *fileserv.FileServ `dim:"on"`
	DB   *dbserv.DBServ     `dim:"on"`
}

func (b *Book) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("", b.List)
	d.RouteFunc("/:bookid", func(d *dim.Group) {

	}, &middles.BookParamMiddle{}, &middles.BookOfUserMiddle{})
}

func (b *Book) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	books, err := b.DB.GetBooksOfUser(c.Tx, &c.User)
	if err != nil {
		return err
	}
	return c.JSON(200, books)
}
