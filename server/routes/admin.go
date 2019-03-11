package routes

import (
	"gorani/book/bookparse"
	"gorani/models/sens"

	"github.com/labstack/echo"

	"github.com/sunho/dim"
)

type Admin struct {
}

func (a *Admin) Register(d *dim.Group) {
	d.Route("/books", &AdminBooks{})
	d.GET("/utils/initial.sens", a.InitialSens)
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
