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

type Progress struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (c *Progress) Register(d *dim.Group) {
	d.Use(&middles.AuthMiddle{})
	d.GET("/:bookid", c.Get)
	d.PUT("/:bookid", c.Put)
}

func (m *Progress) Get(c *models.Context) error {
	out, err := c.User.GetBookProgress(c.Param("bookid"))
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (m *Progress) Put(c *models.Context) error {
	input := struct {
		ReadPages int `json:"read_pages"`
	}{}
	if err := c.Bind(&input); err != nil {
		return err
	}
	id, err := strconv.Atoi(c.Param("bookid"))
	if err != nil {
		return err
	}
	var item models.UserBookProgress
	item.UserID = c.User.ID
	item.BookID = id
	item.ReadPages = input.ReadPages
	err = m.DB.Upsert(&item)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}
