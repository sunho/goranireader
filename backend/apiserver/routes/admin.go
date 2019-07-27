//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/book/bookparse"
	"gorani/models"
	"gorani/utils"
	"mime"
	"strconv"

	"github.com/sunho/webf/servs/s3serv"

	"github.com/gobuffalo/nulls"
	"go.uber.org/zap"

	"github.com/sunho/dim"
)

type Admin struct {
	File *s3serv.S3Serv `dim:"on"`
}

func (a *Admin) Register(d *dim.Group) {
	d.Route("/book", &AdminBook{})
	d.POST("/util/book-from-epub", a.BookFromEpub)
	d.GET("/student", a.GetStudent)
	d.GET("/mission", a.GetMission)
	d.POST("/mission", a.PostMission)
	d.DELETE("/mission/:missionid", a.DeleteMission)
}

type Student struct {
	Name              string `json:"name"`
	CompletedMissions []int  `json:"complted_missions"`
}

func (a *Admin) GetStudent(c *models.Context) error {
	var ss []models.User
	err := c.Tx.Where("class_id = 1").All(&ss)
	if err != nil {
		return err
	}

	out := []Student{}
	for _, s := range ss {
		var ps []models.UserMissionProgress
		err = c.Tx.Where("user_id = ?", s.ID).All(&ps)
		if err != nil {
			return err
		}
		cp := []int{}
		for _, p := range ps {
			var m models.ClassMission
			err = c.Tx.Where("id = ?", p.MissionID).First(&m)
			if p.ReadPages >= m.Pages {
				cp = append(cp, m.ID)
			}
		}
		out = append(out, Student{
			Name:              s.Username,
			CompletedMissions: cp,
		})
	}
	return c.JSON(200, out)
}

func (a *Admin) GetMission(c *models.Context) error {
	var out []models.ClassMission
	err := c.Tx.Where("class_id = 1").All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (a *Admin) PostMission(c *models.Context) error {
	var input models.ClassMission
	err := c.Bind(&input)
	if err != nil {
		return err
	}
	err = c.Tx.Create(&input)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (a *Admin) DeleteMission(c *models.Context) error {
	id, err := strconv.Atoi(c.Param("missionid"))
	if err != nil {
		return err
	}
	var out models.ClassMission
	err = c.Tx.Where("id = ?", id).First(&out)
	if err != nil {
		return err
	}
	err = c.Tx.Destroy(&out)
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (a *Admin) BookFromEpub(c *models.Context) error {
	f, err := c.FormFile("file")
	if err != nil {
		return err
	}

	r, err := f.Open()
	if err != nil {
		return err
	}
	defer r.Close()
	utils.Log.Info("Asdf", zap.Int64("size", f.Size))
	b, err := bookparse.Parse("asdf", r, f.Size)
	if err != nil {
		return err
	}
	utils.Log.Info("Asdf2")
	cover, err := a.File.UploadFile(b.Cover.Reader, mime.TypeByExtension("."+b.Cover.Ext), b.Cover.Ext)
	if err != nil {
		return err
	}

	book := models.Book{
		ISBN:       "asdf",
		Name:       b.Name,
		Author:     b.Author,
		Cover:      cover,
		Categories: utils.SQLStrings{},
	}
	utils.Log.Info("Asdf3")

	err = c.Tx.Eager().Create(&book)
	if err != nil {
		return err
	}

	c.BookParam = book
	// TODO separate

	f, err = c.FormFile("file")
	if err != nil {
		return err
	}

	r, err = f.Open()
	if err != nil {
		return err
	}
	defer r.Close()
	utils.Log.Info("Asdf3")
	url, err := a.File.UploadFileHeader(f)
	if err != nil {
		return err
	}

	c.BookParam.Epub.Epub = nulls.NewString(url)

	err = c.Tx.Update(&c.BookParam.Epub)
	if err != nil {
		return err
	}
	utils.Log.Info("Asdf4")
	return c.NoContent(200)
}
