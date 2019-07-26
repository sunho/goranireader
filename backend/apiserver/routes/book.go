//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/servs/dbserv"
	"gorani/servs/fileserv"
	"gorani/servs/googleserv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Book struct {
	File   *fileserv.FileServ     `dim:"on"`
	Google *googleserv.GoogleServ `dim:"on"`
	DB     *dbserv.DBServ         `dim:"on"`
}

func (b *Book) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("", b.List)
}

func (b *Book) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	code := c.Request().Header.Get("X-Auth-Code")
	cli, err := b.Google.GetClient(code)
	if err != nil {
		return err
	}

	ids, err := cli.GetBookIDs()
	if err != nil {
		return err
	}

	out := make([]dbmodels.Book, 0, len(ids))
	for _, id := range ids {
		var book dbmodels.Book
		err := c.Tx.Q().Where("google_id = ?", id).First(&book)
		if err == nil {
			out = append(out, book)
		}
	}

	return c.JSON(200, out)
}
