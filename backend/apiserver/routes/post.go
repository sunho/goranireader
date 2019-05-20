package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/models/dbmodels"
	"strconv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Post struct {
}

func (p *Post) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("", p.List)
	d.GET("/sentence-search", p.List)
	d.POST("", m.ListSimilarWord)
	d.RouteFunc("/:postid", func(d *dim.Group) {
		d.DELETE("", m.Get)
		d.GET("/rate", m.Fet)
		d.RouteFunc("/sentence", func(d *dim.Group) {
			d.POST("/solve", m.Fet)
		})
		d.Route("/rate", &Rate{kind: "memory", targetID: func(c *models.Context) int {
			return c.MemoryParam.ID
		}})
		d.RouteFunc("/comments", func(d *dim.Group) {
			d.POST("", m.Get)
			d.GET("", m.Get)
			d.DELETE("/:commentid", m.Get)
			d.Route("/:commentid/rate", &Rate{kind: "memory", targetID: func(c *models.Context) int {
				return c.MemoryParam.ID
			}})
		})
	}, &middles.MemoryParamMiddle{})
}

func (p *Post) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	var out []dbmodels.DetailedMemory
	p, _ := strconv.Atoi(c.QueryParam("p"))
	err := c.Tx.Where("word = ?", c.Param("word")).Paginate(p, memoriesPerPage).All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}
