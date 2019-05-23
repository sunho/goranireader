//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/middles"
	"gorani/models"
	"gorani/models/datamodels"
	"gorani/servs/dataserv"
	"gorani/utils"
	"time"

	"github.com/labstack/echo"

	"github.com/sunho/dim"
)

type Evlog struct {
	Data *dataserv.DataServ `dim:"on"`
}

func (ev *Evlog) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.POST("", ev.Post)
}

func (ev *Evlog) Post(c2 echo.Context) error {
	c := c2.(*models.Context)
	var evlog datamodels.UserEventLog
	if err := c.Bind(&evlog); err != nil {
		return err
	}
	evlog.UserID = c.User.ID
	evlog.Day = utils.RoundTime(time.Now().UTC())
	if err := ev.Data.AddUserEventLog(&evlog); err != nil {
		return err
	}
	return c.NoContent(201)
}
