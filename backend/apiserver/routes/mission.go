//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

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

type Mission struct {
	DB dbserv.DBServ `dim:"on"`
}

func (c *Mission) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("/", c.List)
	d.PUT("/:missionid/progress", c.Put)
}

func (m *Mission) List(c2 echo.Context) error {
	c := c2.(*models.Context)
	var out []dbmodels.Mission
	err := c.Tx.Q().Where("class_id = ?", c.User.ClassID).All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (m *Mission) Put(c2 echo.Context) error {
	c := c2.(*models.Context)
	input := struct {
		ReadPages int `json:"read_pages"`
	}{}
	if err := c.Bind(&input); err != nil {
		return err
	}
	id, err := strconv.Atoi(c.Param("missionid"))
	if err != nil {
		return err
	}
	var item dbmodels.MissionProgress
	item.UserID = c.User.ID
	item.MissionID = id
	item.ReadPages = input.ReadPages
	err = m.DB.Upsert(c.Tx, item)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}
