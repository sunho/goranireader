//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/middles"
	"gorani/models"
	"strconv"

	"github.com/sunho/webf/servs/dbserv"

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
	d.PUT("/:word", m.Post)
	d.RouteFunc("/:word/:memoryid", func(d *dim.Group) {
		d.GET("", m.Get)
		d.DELETE("", m.Delete)
	}, &middles.MemoryParamMiddle{})
}

func (m *Memory) List(c *models.Context) error {
	var out []models.DetailedMemory
	p, _ := strconv.Atoi(c.QueryParam("p"))
	err := c.Tx.Where("word = ?", c.Param("word")).Paginate(p, memoriesPerPage).All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (m *Memory) Post(c *models.Context) error {
	var memory models.Memory
	if err := c.Bind(&memory); err != nil {
		return err
	}
	memory.UserID = c.User.ID
	memory.Word = c.Param("word")
	if err := m.DB.Upsert(&memory); err != nil {
		return err
	}
	return c.NoContent(200)
}

func (m *Memory) Get(c *models.Context) error {
	return c.JSON(200, c.MemoryParam)
}

func (m *Memory) Put(c *models.Context) error {
	if c.MemoryParam.UserID != c.User.ID {
		return echo.NewHTTPError(403, "That's not your memory")
	}
	var memory models.Memory
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

func (m *Memory) Delete(c *models.Context) error {
	if c.MemoryParam.UserID != c.User.ID {
		return echo.NewHTTPError(403, "That's not your memory")
	}
	err := c.Tx.Destroy(c.MemoryParam)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}
