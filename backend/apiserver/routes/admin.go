package routes

import (
	"gorani/book/bookparse"
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/models/sens"
	"gorani/servs/fileserv"
	"gorani/utils"
	"mime"

	"github.com/gobuffalo/nulls"
	"github.com/labstack/echo"

	"github.com/sunho/dim"
)

type Admin struct {
	File *fileserv.FileServ `dim:"on"`
}

func (a *Admin) Register(d *dim.Group) {
	d.Route("/book", &AdminBook{})
	d.GET("/util/initial.sens", a.InitialSens)
	d.POST("/util/book-from-epub", a.BookFromEpub)
}

func (a *Admin) InitialSens(c echo.Context) error {
	f, err := c.FormFile("file")
	if err != nil {
		return err
	}
	r, err := f.Open()
	if err != nil {
		return err
	}
	defer r.Close()
	b, err := bookparse.Parse("", r, f.Size)
	if err != nil {
		return err
	}
	out, err := sens.NewFromBook(b)
	if err != nil {
		return err
	}
	return c.Blob(200, sens.MIME, out.Encode())
}

func (a *Admin) BookFromEpub(c2 echo.Context) error {
	c := c2.(*models.Context)
	f, err := c.FormFile("file")
	if err != nil {
		return err
	}

	r, err := f.Open()
	if err != nil {
		return err
	}
	defer r.Close()

	b, err := bookparse.Parse("", r, f.Size)
	if err != nil {
		return err
	}

	cover, err := a.File.UploadFile(b.Cover.Reader, mime.TypeByExtension("."+b.Cover.Ext), b.Cover.Ext)
	if err != nil {
		return err
	}

	book := dbmodels.Book{
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

	c.BookParam = book
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

	c.BookParam.Epub.Epub = nulls.NewString(url)

	err = c.Tx.Update(&c.BookParam.Epub)
	if err != nil {
		return err
	}

	return c.NoContent(200)
}
