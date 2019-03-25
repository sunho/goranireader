package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/servs/dbserv"
	"strconv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

const reviewsPerPage = 10

type BookReview struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (b *BookReview) Register(d *dim.Group) {
	d.GET("", b.List)
	d.POST("", b.Post)
	d.RouteFunc("/:reviewid", func(d *dim.Group) {
		d.GET("", b.Get)
		d.PUT("", b.Put)
		d.DELETE("", b.Delete)
		d.PUT("/rate", b.PutRate)
	}, &middles.ReviewParamMiddle{})
}

func (b *BookReview) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	p, _ := strconv.Atoi(c.QueryParam("p"))
	var out []dbmodels.Review
	err := c.Tx.Where("book_id = ?", c.BookParam.ID).
		Paginate(p, reviewsPerPage).
		All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (b *BookReview) Post(c2 echo.Context) error {
	c := c2.(*models.Context)
	var review dbmodels.Review
	if err := c.Bind(&review); err != nil {
		return err
	}
	review.ID = 0
	review.UserID = c.User.ID
	review.BookID = c.BookParam.ID
	err := c.Tx.Create(&review)
	if err != nil {
		return err
	}
	return c.NoContent(201)
}

func (b *BookReview) Get(c2 echo.Context) error {
	c := c2.(*models.Context)
	return c.JSON(200, c.ReviewParam)
}

func (b *BookReview) Put(c2 echo.Context) error {
	c := c2.(*models.Context)
	if c.User.ID != c.ReviewParam.UserID {
		return echo.NewHTTPError(403, "That's not your review")
	}
	var review dbmodels.Review
	if err := c.Bind(&review); err != nil {
		return err
	}
	review.ID = c.ReviewParam.ID
	review.BookID = c.ReviewParam.BookID
	review.UserID = c.ReviewParam.UserID
	err := c.Tx.Update(&review)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (b *BookReview) Delete(c2 echo.Context) error {
	c := c2.(*models.Context)
	if c.User.ID != c.ReviewParam.UserID {
		return echo.NewHTTPError(403, "That's not your review")
	}
	err := c.Tx.Destroy(c.ReviewParam)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (b *BookReview) PutRate(c2 echo.Context) error {
	c := c2.(*models.Context)
	var rate dbmodels.ReviewRate
	if err := c.Bind(&rate); err != nil {
		return err
	}
	rate.UserID = c.User.ID
	rate.ReviewID = c.ReviewParam.ID

	err := b.DB.Upsert(c.Tx, &rate)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}
