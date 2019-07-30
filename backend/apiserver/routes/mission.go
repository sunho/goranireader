//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/middles"
	"gorani/models"

	"github.com/sunho/webf/servs/dbserv"

	"github.com/sunho/dim"
)

type Mission struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (c *Mission) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("", c.Get)
}

func (m *Mission) Get(c *models.Context) error {
	class, err := c.User.GetClass()
	if err != nil {
		return err
	}
	mission, err := class.GetCurrentMission()
	if err != nil {
		return err
	}
	return c.JSON(200, mission)
}
