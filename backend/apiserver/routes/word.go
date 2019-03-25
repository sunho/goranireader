package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/servs/dbserv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Word struct {
}

func (u *Word) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.Route("/uword", &Uword{})
	d.Route("/nword", &Nword{})
}

type Uword struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (u *Uword) Register(d *dim.Group) {
	d.GET("", u.List)
	d.PUT("/:word", u.Put)
	d.DELETE("/:word", u.Delete)
}

func (u *Uword) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	var out []dbmodels.UnknownWord
	c.Tx.Where("user_id = ?", c.User.ID).All(&out)
	return c.JSON(200, out)
}

func (u *Uword) Put(c2 echo.Context) error {
	c := c2.(*models.Context)
	var word dbmodels.UnknownWord
	if err := c.Bind(&word); err != nil {
		return err
	}
	word.UserID = c.User.ID
	word.Word = c.Param("word")
	err := u.DB.Upsert(c.Tx, &word)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (u *Uword) Delete(c2 echo.Context) error {
	c := c2.(*models.Context)

	var word dbmodels.UnknownWord
	err := c.Tx.
		Where("user_id = ? and word = ?", c.User.ID, c.Param("word")).
		First(&word)
	if err != nil {
		return err
	}
	err = c.Tx.Destroy(&word)
	if err != nil {
		return err
	}

	return c.NoContent(200)
}

type Nword struct {
}

func (n *Nword) Register(d *dim.Group) {
	d.POST("/:word", n.Post)
	d.DELETE("/:word", n.Delete)
}

func (n *Nword) Post(c2 echo.Context) error {
	c := c2.(*models.Context)
	var word dbmodels.KnownWord
	exists, err := c.Tx.Where("user_id = ? and word = ?", c.User.ID, c.Param("word")).Exists(&word)
	if err != nil {
		return err
	}
	if !exists {
		err = c.Tx.Create(&dbmodels.KnownWord{
			UserID: c.User.ID,
			Word:   c.Param("word"),
		})
		if err != nil {
			return err
		}
	} else {
		word.N = word.N + 1
		err = c.Tx.Update(&word)
		if err != nil {
			return err
		}
	}
	return c.NoContent(200)
}

func (n *Nword) Delete(c2 echo.Context) error {
	c := c2.(*models.Context)
	var word dbmodels.KnownWord
	err := c.Tx.Where("user_id = ? and word = ?", c.User.ID, c.Param("word")).First(&word)
	if err != nil {
		return c.NoContent(200)
	} else {
		word.N = word.N - 1
		if word.N == 0 {
			err = c.Tx.Destroy(&word)
			if err != nil {
				return err
			}
		} else {
			err = c.Tx.Update(&word)
			if err != nil {
				return err
			}
		}
	}
	return c.NoContent(200)
}
