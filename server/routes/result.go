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

type Result struct {
}

func (p *Result) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.Route("/quiz", &ResultQuiz{})
	d.Route("/sens", &ResultSens{})
}

type ResultQuiz struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (r *ResultQuiz) Register(d *dim.Group) {
	d.RouteFunc("/:bookid", func(d *dim.Group) {
		d.GET("", r.List)
		d.PUT("/:quizid", r.Put)
		d.DELETE("/:quizid", r.DeleteOne)
	}, &middles.BookParamMiddle{})
}

func (r *ResultQuiz) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	var out []dbmodels.QuizResult
	err := c.Tx.Where("user_id = ? and book_id = ?", c.User.ID, c.BookParam.ID).All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (r *ResultQuiz) Put(c2 echo.Context) error {
	c := c2.(*models.Context)
	var res dbmodels.QuizResult
	if err := c.Bind(&res); err != nil {
		return err
	}
	id, err := strconv.Atoi(c.Param("quizid"))
	if err != nil {
		return err
	}
	res.UserID = c.User.ID
	res.BookID = c.BookParam.ID
	res.QuizID = id
	err = r.DB.Upsert(c.Tx, &res)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (r *ResultQuiz) DeleteOne(c2 echo.Context) error {
	c := c2.(*models.Context)
	var res dbmodels.QuizResult
	id, err := strconv.Atoi(c.Param("quizid"))
	if err != nil {
		return err
	}
	err = c.Tx.Where("user_id = ? and book_id = ? and quiz_id = ?", c.User.ID, c.BookParam.ID, id).First(&res)
	if err != nil {
		return err
	}
	err = c.Tx.Destroy(&res)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

type ResultSens struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (r *ResultSens) Register(d *dim.Group) {
	d.RouteFunc("/:bookid", func(d *dim.Group) {
		d.GET("", r.List)
		d.PUT("/:sensid", r.Put)
		d.DELETE("/:sensid", r.DeleteOne)
	}, &middles.BookParamMiddle{})
}

func (r *ResultSens) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	var out []dbmodels.QuizResult
	err := c.Tx.Where("user_id = ? and book_id = ?", c.User.ID, c.BookParam.ID).All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (r *ResultSens) Put(c2 echo.Context) error {
	c := c2.(*models.Context)
	var res dbmodels.SensResult
	if err := c.Bind(&res); err != nil {
		return err
	}
	id, err := strconv.Atoi(c.Param("sensid"))
	if err != nil {
		return err
	}
	res.UserID = c.User.ID
	res.BookID = c.BookParam.ID
	res.SensID = id
	err = r.DB.Upsert(c.Tx, &res)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (r *ResultSens) DeleteOne(c2 echo.Context) error {
	c := c2.(*models.Context)
	var res dbmodels.SensResult
	id, err := strconv.Atoi(c.Param("sensid"))
	if err != nil {
		return err
	}
	err = c.Tx.Where("user_id = ? and book_id = ? and sens_id = ?", c.User.ID, c.BookParam.ID, id).First(&res)
	if err != nil {
		return err
	}
	err = c.Tx.Destroy(&res)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}
