package routes

import (
	"gorani/book/bookparse"
	"gorani/middles"
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/servs/fileserv"

	"github.com/gobuffalo/nulls"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type AdminBook struct {
	File *fileserv.FileServ `dim:"on"`
}

func (a *AdminBook) Register(g *dim.Group) {
	g.POST("", a.Post)
	g.RouteFunc("/:bookid", func(g *dim.Group) {
		g.PUT("", a.Put)
		g.DELETE("", a.Delete)
		g.PUT("/epub", a.PutEpub)
		g.PUT("/sens", a.PutSens)
	}, &middles.BookParamMiddle{})

}

func (a *AdminBook) Post(c2 echo.Context) error {
	c := c2.(*models.Context)
	var book dbmodels.Book
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

func (a *AdminBook) Put(c2 echo.Context) error {
	c := c2.(*models.Context)
	var book dbmodels.Book
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

func (a *AdminBook) Delete(c2 echo.Context) error {
	c := c2.(*models.Context)
	err := c.Tx.Destroy(&c.BookParam)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (a *AdminBook) PutEpub(c2 echo.Context) error {
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

	err = a.uploadWords(c, c.BookParam.ID, b)
	if err != nil {
		return err
	}

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

func (a *AdminBook) PutSens(c2 echo.Context) error {
	c := c2.(*models.Context)
	f, err := c.FormFile("file")
	if err != nil {
		return err
	}

	url, err := a.File.UploadFileHeader(f)
	if err != nil {
		return err
	}

	c.BookParam.Sens.Sens = nulls.NewString(url)

	err = c.Tx.Update(&c.BookParam.Sens)
	if err != nil {
		return err
	}

	return c.NoContent(200)
}

func (a *AdminBook) uploadWords(c *models.Context, id int, b bookparse.Book) error {
	var words []dbmodels.BookWord
	err := c.Tx.Where("book_id = ?", id).All(&words)
	if err != nil {
		return err
	}

	err = c.Tx.Destroy(words)
	if err != nil {
		return err
	}

	wordmap := make(map[string]int)
	for _, sen := range b.Sentences {
		for _, word := range sen.Words {
			if n, ok := wordmap[string(word)]; ok {
				wordmap[string(word)] = n + 1
			} else {
				wordmap[string(word)] = 1
			}
		}
	}

	for word, n := range wordmap {
		err = c.Tx.Create(&dbmodels.BookWord{
			BookID: id,
			Word:   word,
			N:      n,
		})
		if err != nil {
			return err
		}
	}
	return nil
}
