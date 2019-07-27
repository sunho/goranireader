//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/middles"
	"gorani/models"

	"github.com/sunho/webf/servs/s3serv"

	"github.com/gobuffalo/nulls"

	"github.com/sunho/dim"
)

type AdminBook struct {
	File *s3serv.S3Serv `dim:"on"`
}

func (a *AdminBook) Register(g *dim.Group) {
	g.POST("", a.Post)
	g.RouteFunc("/:bookid", func(g *dim.Group) {
		g.PUT("", a.Put)
		g.DELETE("", a.Delete)
		g.PUT("/epub", a.PutEpub)
	}, &middles.BookParamMiddle{})

}

func (a *AdminBook) Post(c *models.Context) error {
	var book models.Book
	if err := c.Bind(&book); err != nil {
		return err
	}
	book.ID = 0
	err := c.Tx.Eager().Create(&book)
	if err != nil {
		return err
	}
	return c.NoContent(201)
}

func (a *AdminBook) Put(c *models.Context) error {
	var book models.Book
	if err := c.Bind(&book); err != nil {
		return err
	}
	book.ID = c.BookParam.ID
	err := c.Tx.Update(&book)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (a *AdminBook) Delete(c *models.Context) error {
	err := c.Tx.Destroy(&c.BookParam)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (a *AdminBook) PutEpub(c *models.Context) error {
	f, err := c.FormFile("file")
	if err != nil {
		return err
	}

	r, err := f.Open()
	if err != nil {
		return err
	}
	defer r.Close()

	url, err := a.File.UploadFileHeader(f)
	if err != nil {
		return err
	}

	c.BookParam.Epub.Epub = nulls.NewString(url)

	err = c.Tx.Update(&c.BookParam.Epub)
	if err != nil {
		return err
	}

	return c.NoContent(200)
}
