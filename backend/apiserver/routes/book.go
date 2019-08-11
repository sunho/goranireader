//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/middles"
	"gorani/models"

	"github.com/sunho/webf/servs/dbserv"
	"github.com/sunho/webf/servs/s3serv"

	"github.com/sunho/dim"
)

type Book struct {
	File *s3serv.S3Serv `dim:"on"`
	DB   *dbserv.DBServ `dim:"on"`
}

func (b *Book) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("/:bookid", b.Get)
}

func (b *Book) Get(c *models.Context) error {
	id := c.Param("bookid")
	var out models.Book
	err := c.Tx.Q().Eager().Where("id = ?", id).First(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}
