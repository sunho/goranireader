//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/servs/dataserv"
	"gorani/servs/dbserv"
	"strconv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

const memoriesPerPage = 10

type Memory struct {
	DB   *dbserv.DBServ     `dim:"on"`
	Data *dataserv.DataServ `dim:"on"`
}

func (m *Memory) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("/:word", m.List)
	d.GET("/:word/similar", m.ListSimilarWord)
	d.PUT("/:word", m.Post)
	d.RouteFunc("/:word/:memoryid", func(d *dim.Group) {
		d.GET("", m.Get)
		d.DELETE("", m.Delete)
		d.Route("/rate", &Rate{kind: "memory", targetID: func(c *models.Context) int {
			return c.MemoryParam.ID
		}})
	}, &middles.MemoryParamMiddle{})
}

func (m *Memory) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	var out []dbmodels.DetailedMemory
	p, _ := strconv.Atoi(c.QueryParam("p"))
	err := c.Tx.Where("word = ?", c.Param("word")).Paginate(p, memoriesPerPage).All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (m *Memory) ListSimilarWord(c2 echo.Context) error {
	c := c2.(*models.Context)

	out, err := m.Data.GetSimilarWords(c.User.ID, c.Param("word"))
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
	if err := m.DB.Upsert(c.Tx, &memory); err != nil {
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
