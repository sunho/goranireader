//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/models"

	"github.com/sunho/webf/servs/dbserv"

	"github.com/labstack/echo"
	"github.com/sunho/dim"
)

type Rate struct {
	DB       *dbserv.DBServ `dim:"on"`
	kind     string
	targetID func(c *models.Context) int
}

func (r *Rate) Register(d *dim.Group) {
	d.GET("", r.Get)
	d.PUT("", r.Put)
}

func (r *Rate) Get(c *models.Context) error {
	var out models.Rate
	err := c.Tx.Where("user_id = ? AND kind = ? AND target_id = ?", c.User.ID, r.kind, r.targetID(c)).First(&out)
	if err != nil {
		return echo.NewHTTPError(404, "no such resource")
	}
	return c.JSON(200, out)
}

func (r *Rate) Put(c *models.Context) error {
	var item models.Rate
	if err := c.Bind(&item); err != nil {
		return err
	}
	item.UserID = c.User.ID
	item.Kind = r.kind
	item.TargetID = r.targetID(c)
	if err := r.DB.Upsert(&item); err != nil {
		return err
	}
	return c.NoContent(200)
}
