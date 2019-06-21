//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/book/bookparse"
	"gorani/models"
	"gorani/models/dbmodels"
	"gorani/models/sens"
	"gorani/servs/fileserv"
	"gorani/utils"
	"strconv"
	"mime"

	"github.com/gobuffalo/nulls"
	"github.com/labstack/echo"
	"go.uber.org/zap"

	"github.com/sunho/dim"
)

type Admin struct {
	File *fileserv.FileServ `dim:"on"`
}

func (a *Admin) Register(d *dim.Group) {
	d.Route("/book", &AdminBook{})
	d.GET("/util/initial.sens", a.InitialSens)
	d.POST("/util/book-from-epub", a.BookFromEpub)
	d.GET("/student", a.GetStudent)
	d.GET("/mission", a.GetMission)
	d.POST("/mission", a.PostMission)
	d.DELETE("/mission/:missionid", a.DeleteMission)
}

type Student struct {
	Name string `json:"name"`
	CompletedMissions []int `json:"complted_missions"`
}

func (a *Admin) GetStudent(c2 echo.Context) error {
	c := c2.(*models.Context)
	var ss []dbmodels.User
	err := c.Tx.Where("class_id = 1").All(&ss)
	if err != nil {
		return err
	}

	out := []Student{}
	for _, s := range ss {
		var ps []dbmodels.UserMissionProgress
		err = c.Tx.Where("user_id = ?", s.ID).All(&ps)
		if err != nil {
			return err
		}
		cp := []int{}
		for _, p := range ps {
			var m dbmodels.ClassMission
			err = c.Tx.Where("id = ?", p.MissionID).First(&m)
			if p.ReadPages >= m.Pages {
				cp = append(cp, m.ID)
			}
		}
		out = append(out, Student{
			Name: s.Username,
			CompletedMissions: cp,
		})
	}
	return c.JSON(200, out)
}

func (a *Admin) GetMission(c2 echo.Context) error {
	c := c2.(*models.Context)
	var out []dbmodels.ClassMission
	err := c.Tx.Where("class_id = 1").All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (a *Admin) PostMission(c2 echo.Context) error {
	c := c2.(*models.Context)
	var input dbmodels.ClassMission
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

func (a *Admin) DeleteMission(c2 echo.Context) error {
	c := c2.(*models.Context)
	id, err := strconv.Atoi(c.Param("missionid"))
	if err != nil {
		return err
	}
	var out dbmodels.ClassMission
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

func (a *Admin) InitialSens(c echo.Context) error {
	f, err := c.FormFile("file")
	if err != nil {
		return err
	}
	r, err := f.Open()
	if err != nil {
		return err
	}
	defer r.Close()
	b, err := bookparse.Parse("", r, f.Size)
	if err != nil {
		return err
	}
	out, err := sens.NewFromBook(b)
	if err != nil {
		return err
	}
	return c.Blob(200, sens.MIME, out.Encode())
}

func (a *Admin) BookFromEpub(c2 echo.Context) error {
	c := c2.(*models.Context)
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

	book := dbmodels.Book{
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
