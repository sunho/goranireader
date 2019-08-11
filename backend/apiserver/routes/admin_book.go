//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"bytes"
	"gorani/booky"
	"gorani/middles"
	"gorani/models"
	"image"
	_ "image/gif"
	_ "image/jpeg"
	_ "image/png"
	"mime"

	"io"

	"github.com/sunho/webf/servs/s3serv"
	"github.com/vmihailenco/msgpack"

	"github.com/sunho/dim"
)

type AdminBook struct {
	File *s3serv.S3Serv `dim:"on"`
}

func guessImageFormat(r io.Reader) (format string, err error) {
	_, format, err = image.DecodeConfig(r)
	return
}

func guessImageMimeTypes(r io.Reader) string {
	format, _ := guessImageFormat(r)
	if format == "" {
		return ""
	}
	return mime.TypeByExtension("." + format)
}

func (a *AdminBook) Register(g *dim.Group) {
	g.POST("", a.Upload)
	g.PUT("", a.Put)
	g.RouteFunc("/:bookid", func(g *dim.Group) {
		g.DELETE("", a.Delete)
	}, &middles.BookParamMiddle{})
}

func (a *AdminBook) Upload(c *models.Context) error {
	f, err := c.FormFile("file")
	if err != nil {
		return err
	}

	r, err := f.Open()
	if err != nil {
		return err
	}
	defer r.Close()

	var book booky.Book
	err = msgpack.NewDecoder(r).Decode(&book)
	if err != nil {
		return err
	}
	var cover string
	if len(book.Meta.Cover) != 0 {
		r2 := bytes.NewReader(book.Meta.Cover)
		r3 := bytes.NewReader(book.Meta.Cover)
		c, err := a.File.UploadFile(r2, guessImageMimeTypes(r3), "")
		if err != nil {
			return err
		}
		cover = c
	}

	url, err := a.File.UploadFileHeader(f)
	if err != nil {
		return err
	}

	item := models.Book{
		ID:           book.Meta.ID,
		Cover:        cover,
		Name:         book.Meta.Title,
		Author:       book.Meta.Author,
		DownloadLink: url,
	}
	err = c.Tx.Upsert(&item)
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
