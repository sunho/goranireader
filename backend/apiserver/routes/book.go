//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/servs/googleserv"

	"github.com/sunho/webf/servs/dbserv"
	"github.com/sunho/webf/servs/s3serv"

	"github.com/sunho/dim"
)

type Book struct {
	File   *s3serv.S3Serv         `dim:"on"`
	Google *googleserv.GoogleServ `dim:"on"`
	DB     *dbserv.DBServ         `dim:"on"`
}

func (b *Book) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("", b.List)
}

func (b *Book) List(c *models.Context) error {
	cli, err := b.Google.GetClient(c.User)
	if err != nil {
		return err
	}
	defer cli.Clean()

	ids, err := cli.GetBookIDs()
	if err != nil {
		return err
	}

	out := make([]models.Book, 0, len(ids))
	for _, id := range ids {
		var book models.Book
		err := c.Tx.Q().Where("google_id = ?", id).First(&book)
		if err == nil {
			out = append(out, book)
		}
	}

	return c.JSON(200, out)
}
