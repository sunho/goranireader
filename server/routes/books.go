package routes

import (
	"gorani/models"
	"gorani/services/dbserv"
	"gorani/services/fileserv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Books struct {
	File *fileserv.FileServ `dim:"on"`
	DB   *dbserv.DBServ     `dim:"on"`
}

func (b *Books) Register(d *dim.Group) {
	d.GET("/", b.list)
	d.POST("/", b.post)
}

func (b *Books) list(c echo.Context) error {
	name := c.QueryParam("name")
	out := []models.Book{}
	err := b.DB.Where("name LIKE ?", "%"+ name+"%").All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (b *Books) post(c echo.Context) error {
	file, err := c.FormFile("file")
	if err != nil {
		return err
	}
	epubURL, err := b.File.UploadFileHeader(file)
	if err != nil {
		return err
	}
	img, err := c.FormFile("img")
	if err != nil {
		return err
	}
	imgURL, err := b.File.UploadFileHeader(img)
	if err != nil {
		return err
	}

	item := models.Book {
		Name: c.FormValue("name"),
		Epub: epubURL,
		Img: imgURL,
	}
	err = b.DB.Create(&item)
	if err != nil {
		return err
	}
	return c.NoContent(201)
}
