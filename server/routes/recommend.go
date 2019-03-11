package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/models/dbmodels"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Recommend struct {
}

func (r *Recommend) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
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
