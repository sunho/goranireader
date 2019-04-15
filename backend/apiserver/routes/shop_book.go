package routes

import (
	"encoding/json"
	"fmt"
	"gorani/middles"
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/servs/dbserv"
	"strconv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

const booksPerPage = 10

type ShopBook struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (s *ShopBook) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("", s.List)
	d.RouteFunc("/:bookid", func(d *dim.Group) {
		d.Use(&middles.BookParamMiddle{})
		d.GET("", s.Get)
		d.Route("/rate", &Rate{kind: "book", targetID: func(c *models.Context) int {
			return c.BookParam.ID
		}})
		d.POST("/buy", s.PostBuy)
	})
}

func (s *ShopBook) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	name := c.QueryParam("name")
	p, _ := strconv.Atoi(c.QueryParam("p"))
	by := c.QueryParam("by")
	out := []dbmodels.ShopBook{}
	err := c.Tx.Eager().Where("user_id = ? OR user_id is NULL", c.User.ID).Where("name LIKE ?", "%"+name+"%").
		Paginate(p, booksPerPage).Order(by).
		All(&out)
	if err != nil {
		return err
	}
	str, _ := json.Marshal(out)
	fmt.Println(string(str))
	return c.JSON(200, out)
}

func (s *ShopBook) Get(c2 echo.Context) error {
	c := c2.(*models.Context)
	return c.JSON(200, c.BookParam)
}

func (s *ShopBook) PostBuy(c2 echo.Context) error {
	c := c2.(*models.Context)
	err := c.Tx.Create(&dbmodels.UsersBooks{
		UserID: c.User.ID,
		BookID: c.BookParam.ID,
	})
	if err != nil {
		return err
	}
	return c.NoContent(200)
}
