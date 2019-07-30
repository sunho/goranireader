//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/book/bookparse"
	"gorani/models"
	"gorani/utils"
	"mime"
	"strconv"

	"github.com/sunho/webf/servs/s3serv"

	"github.com/gobuffalo/nulls"

	"github.com/sunho/dim"
)

type Admin struct {
	File *s3serv.S3Serv `dim:"on"`
}

func (a *Admin) Register(d *dim.Group) {
	d.Route("/book", &AdminBook{})
	d.POST("/util/book-from-epub", a.BookFromEpub)
	d.Route("/teacher", &AdminTeacher{})
	d.POST("/class", a.PostClass)
	d.DELETE("/class/:classid", a.DeleteClass)
}

func (a *Admin) BookFromEpub(c *models.Context) error {
	f, err := c.FormFile("file")
	if err != nil {
		return err
	}

	r, err := f.Open()
	if err != nil {
		return err
	}
	defer r.Close()
	b, err := bookparse.Parse("asdf", r, f.Size)
	if err != nil {
		return err
	}
	cover, err := a.File.UploadFile(b.Cover.Reader, mime.TypeByExtension("."+b.Cover.Ext), b.Cover.Ext)
	if err != nil {
		return err
	}

	book := models.Book{
		ISBN:       "asdf",
		Name:       b.Name,
		Author:     b.Author,
		Cover:      cover,
		Categories: utils.SQLStrings{},
	}
	err = c.Tx.Eager().Create(&book)
	if err != nil {
		return err
	}

	// TODO separate

	f, err = c.FormFile("file")
	if err != nil {
		return err
	}

	r, err = f.Open()
	if err != nil {
		return err
	}
	defer r.Close()
	url, err := a.File.UploadFileHeader(f)
	if err != nil {
		return err
	}

	book.Epub.Epub = nulls.NewString(url)

	err = c.Tx.Update(&book.Epub)
	if err != nil {
		return err
	}
	return c.JSON(200, book)
}

func (a *Admin) PostClass(c *models.Context) error {
	var class models.Class
	if err := c.Bind(&class); err != nil {
		return err
	}
	err := c.Tx.Create(&class)
	if err != nil {
		return err
	}
	return c.NoContent(201)
}

func (a *Admin) DeleteClass(c *models.Context) error {
	id, err := strconv.Atoi(c.Param("classid"))
	if err != nil {
		return err
	}
	class, err := models.Tx(c.Tx).GetClass(id)
	if err != nil {
		return err
	}
	err = class.Destroy()
	if err != nil {
		return err
	}
	return c.NoContent(200)
}
