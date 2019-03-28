package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/servs/dbserv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Recommend struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (r *Recommend) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("/info", r.GetInfo)
	d.PUT("/info", r.PutInfo)
	d.GET("/book", r.GetBooks)
	d.PUT("/book/:bookid/rate", r.PutRate, &middles.BookParamMiddle{})
}

func (r *Recommend) GetInfo(c2 echo.Context) error {
	c := c2.(*models.Context)
	var info dbmodels.RecommendInfo
	err := c.Tx.Where("user_id = ?", c.User.ID).First(&info)
	if err != nil {
		return err
	}
	return c.JSON(200, info)
}

func (r *Recommend) PutInfo(c2 echo.Context) error {
	c := c2.(*models.Context)
	var new dbmodels.RecommendInfo
	if err := c.Bind(&new); err != nil {
		return err
	}

	var old dbmodels.RecommendInfo
	err := c.Tx.Where("user_id = ?", c.User.ID).First(&old)
	new.ID = old.ID
	new.UserID = old.UserID

	err = c.Tx.Update(&new)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (r *Recommend) GetBooks(c2 echo.Context) error {
	c := c2.(*models.Context)
	var out []dbmodels.RecommendBook
	err := c.Tx.Where("user_id = ?", c.User.ID).All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (r *Recommend) PutRate(c2 echo.Context) error {
	c := c2.(*models.Context)
	var rate dbmodels.Rate
	if err := c.Bind(&rate); err != nil {
		return err
	}
	rate.UserID = c.User.ID
	rate.Kind = "recommended_book"
	rate.TargetID = c.BookParam.ID

	err := r.DB.Upsert(c.Tx, &rate)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}
