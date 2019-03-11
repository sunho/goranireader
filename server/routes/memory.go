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

const memoriesPerPage = 10

type Memory struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (m *Memory) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("/:word", m.List)
	d.POST("/:word", m.Post)
	d.RouteFunc("/:memoryid", func(d *dim.Group) {
		d.GET("", m.Get)
		d.PUT("", m.Put)
		d.DELETE("", m.Delete)
		d.PUT("/rate", m.PutRate)
	}, &middles.MemoryParamMiddle{})
}

func (m *Memory) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	var out []dbmodels.Memory
	p, _ := strconv.Atoi(c.Param("p"))
	err := c.Tx.Where("word = ?", &out).Paginate(p, memoriesPerPage).All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (m *Memory) Post(c2 echo.Context) error {
	c := c2.(*models.Context)
	var memory dbmodels.Memory
	if err := c.Bind(&memory); err != nil {
		return err
	}
	memory.UserID = c.User.ID
	memory.Word = c.Param("word")
	err := c.Tx.Create(&memory)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (m *Memory) Get(c2 echo.Context) error {
	c := c2.(*models.Context)
	return c.JSON(200, c.MemoryParam)
}

func (m *Memory) Put(c2 echo.Context) error {
	c := c2.(*models.Context)
	if c.MemoryParam.UserID != c.User.ID {
		return echo.NewHTTPError(403, "That's not your memory")
	}
	var memory dbmodels.Memory
	if err := c.Bind(&memory); err != nil {
		return err
	}
	memory.ID = c.MemoryParam.ID
	memory.UserID = c.User.ID
	memory.Word = c.MemoryParam.Word
	err := c.Tx.Update(&memory)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (m *Memory) Delete(c2 echo.Context) error {
	c := c2.(*models.Context)
	if c.MemoryParam.UserID != c.User.ID {
		return echo.NewHTTPError(403, "That's not your memory")
	}
	err := c.Tx.Destroy(c.MemoryParam)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (m *Memory) PutRate(c2 echo.Context) error {
	c := c2.(*models.Context)
	var rate dbmodels.MemoryRate
	if err := c.Bind(&rate); err != nil {
		return err
	}
	rate.UserID = c.User.ID
	rate.MemoryID = c.MemoryParam.ID
	err := m.DB.Upsert(c.Tx, &rate)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}
