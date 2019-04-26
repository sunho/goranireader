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
	d.GET("/progress", r.GetProgress)
	d.PUT("/info", r.PutInfo)
	d.GET("/book", r.GetBooks)
	d.DELETE("/book/:bookid", r.DeleteBook, &middles.BookParamMiddle{})
	d.Route("/book/:bookid/rate", &Rate{kind: "recommended_book", targetID: func(c *models.Context) int {
		return c.BookParam.ID
	}}, &middles.BookParamMiddle{})
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
	var out []dbmodels.DetailedRecommendedBook
	err := c.Tx.Where("user_id = ?", c.User.ID).All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (r *Recommend) GetProgress(c2 echo.Context) error {
	c := c2.(*models.Context)
	var info dbmodels.RecommendInfo
	err := c.Tx.Q().Where("user_id = ?", c.User.ID).
		First(&info)
	if err != nil {
		return err
	}
	if !info.TargetBookID.Valid {
		return echo.NewHTTPError(400, "No target book")
	}
	id := info.TargetBookID.Value
	var out dbmodels.TargetBookProgress
	err = c.Tx.Q().Where("user_id = ? AND book_id = ?", c.User.ID, id).
		First(&out)
	if err != nil {
		return echo.NewHTTPError(404, "Progress no calculated yet")
	}
	return c.JSON(200, out)
}

func (r *Recommend) DeleteBook(c2 echo.Context) error {
	c := c2.(*models.Context)
	var item dbmodels.RecommendedBook
	err := c.Tx.Where("user_id = ? AND book_id = ?", c.User.ID, c.BookParam.ID).First(&item)
	if err != nil {
		return err
	}
	err = c.Tx.Destroy(&item)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}
