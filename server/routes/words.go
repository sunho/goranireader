package routes

import (
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/servs/dbserv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Words struct {
}

type Uwords struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (u *Uwords) Register(d *dim.Group) {
	d.GET("", u.List)
	d.PUT("/:word", u.Put)
	d.DELETE("/:word", u.Delete)
}

func (u *Uwords) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	var out []dbmodels.UnknownWord
	c.Tx.Where("user_id = ?", c.User.ID).All(&out)
	return c.JSON(200, out)
}

func (u *Uwords) Put(c2 echo.Context) error {
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

func (u *Uwords) Delete(c2 echo.Context) error {
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

type Nwords struct {
}

func (n *Nwords) Register(d *dim.Group) {
	d.POST("/:word", n.Post)
	d.DELETE("/:word", n.Delete)
}

func (n *Nwords) Post(c2 echo.Context) error {
	c := c2.(*models.Context)
	var word dbmodels.KnownWord
	err := c.Tx.Where("user_id = ? and word = ?", c.User.ID, c.Param("word")).First(&word)
	if err != nil {
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

func (n *Nwords) Delete(c2 echo.Context) error {
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
