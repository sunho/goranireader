//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/middles"
	"gorani/models"
	"strconv"

	"github.com/sunho/webf/servs/dbserv"

	"github.com/sunho/dim"
)

type Mission struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (c *Mission) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("", c.List)
	d.GET("/:missionid/progress", c.Get)
	d.PUT("/:missionid/progress", c.Put)
}

func (m *Mission) List(c *models.Context) error {
	var out []models.ClassMission
	err := c.Tx.Q().Where("class_id = ?", c.User.ClassID.Int).All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (m *Mission) Get(c *models.Context) error {
	id, err := strconv.Atoi(c.Param("missionid"))
	if err != nil {
		return err
	}
	var out models.UserMissionProgress
	err = c.Tx.Q().Where("user_id = ? AND mission_id = ?", c.User.ID, id).
		First(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (m *Mission) Put(c *models.Context) error {
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
	var item models.UserMissionProgress
	item.UserID = c.User.ID
	item.MissionID = id
	item.ReadPages = input.ReadPages
	err = m.DB.Upsert(&item)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}
