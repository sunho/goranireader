//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/models"
	"strconv"

	"github.com/sunho/webf/servs/s3serv"

	"github.com/sunho/dim"
)

type Admin struct {
	File *s3serv.S3Serv `dim:"on"`
}

func (a *Admin) Register(d *dim.Group) {
	d.Route("/book", &AdminBook{})
	d.Route("/teacher", &AdminTeacher{})
	d.POST("/class", a.PostClass)
	d.DELETE("/class/:classid", a.DeleteClass)
}

func (a *Admin) PostClass(c *models.Context) error {
	var class models.Class
	if err := c.Bind(&class); err != nil {
		return err
	}
	err := c.Tx.Create(&class)
	if err != nil {
		return err
	}
	return c.NoContent(201)
}

func (a *Admin) DeleteClass(c *models.Context) error {
	id, err := strconv.Atoi(c.Param("classid"))
	if err != nil {
		return err
	}
	class, err := models.Tx(c.Tx).GetClass(id)
	if err != nil {
		return err
	}
	err = class.Destroy()
	if err != nil {
		return err
	}
	return c.NoContent(200)
}
