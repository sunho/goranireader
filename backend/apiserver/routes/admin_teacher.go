package routes

import (
	"gorani/middles"
	"gorani/models"
	"strconv"

	"github.com/gobuffalo/nulls"
	"github.com/sunho/dim"
	"github.com/sunho/webf/servs/dbserv"
)

const booksPerPage = 10

type AdminTeacher struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (a *AdminTeacher) Register(d *dim.Group) {
	d.GET("/class", a.ListClasses)
	d.GET("/book", a.ListBooks)
	d.GET("/book/:bookid", a.GetBook)
	d.GET("/student", a.ListAllStudents)
	d.RouteFunc("/class/:classid", func(d *dim.Group) {
		d.GET("/student", a.ListStudents)
		d.POST("/student/:studentid", a.PostStudent)
		d.DELETE("/student/:studentid", a.DeleteStudent)
		d.GET("/mission", a.ListMissions)
		d.POST("/mission", a.PostMission)
		d.PUT("/mission/:missionid", a.PutMission)
		d.DELETE("/mission/:missionid", a.DeleteMission)
	}, &middles.ClassParamMiddle{})
}

func (s *AdminTeacher) ListBooks(c *models.Context) error {
	name := c.QueryParam("name")
	p, _ := strconv.Atoi(c.QueryParam("p"))
	by := c.QueryParam("by")
	out := []models.Book{}
	q := c.Tx.Q().Eager().Paginate(p, booksPerPage).Order(by)
	if name != "" {
		q = q.Where("name LIKE ?", "%"+name+"%")
	}
	err := q.All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (a *AdminTeacher) ListAllStudents(c *models.Context) error {
	out := []models.User{}
	err := c.Tx.Q().All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (a *AdminTeacher) ListClasses(c *models.Context) error {
	out := []models.Class{}
	err := c.Tx.Q().All(&out)
	if err != nil {
		return err
	}
	return c.JSON(200, out)
}

func (a *AdminTeacher) ListStudents(c *models.Context) error {
	users, err := c.ClassParam.GetUsers()
	if err != nil {
		return err
	}

	out := []models.StudentView{}
	for _, u := range users {
		view, err := u.GetStudentView()
		if err != nil {
			return err
		}
		out = append(out, view)
	}
	return c.JSON(200, out)
}

func (a *AdminTeacher) ListMissions(c *models.Context) error {
	missions, err := c.ClassParam.GetMissions()
	if err != nil {
		return err
	}
	return c.JSON(200, missions)
}

func (a *AdminTeacher) PostStudent(c *models.Context) error {
	id, err := strconv.Atoi(c.Param("studentid"))
	if err != nil {
		return err
	}
	user, err := models.Tx(c.Tx).GetUser(id)
	if err != nil {
		return err
	}
	user.ClassID = nulls.NewInt(c.ClassParam.ID)
	err = user.Update()
	if err != nil {
		return err
	}
	return c.NoContent(201)
}

func (a *AdminTeacher) DeleteStudent(c *models.Context) error {
	id, err := strconv.Atoi(c.Param("studentid"))
	if err != nil {
		return err
	}
	user, err := models.Tx(c.Tx).GetUser(id)
	if err != nil {
		return err
	}
	user.ClassID = nulls.Int{}
	err = user.Update()
	if err != nil {
		return err
	}
	return c.NoContent(201)
}

func (a *AdminTeacher) PostMission(c *models.Context) error {
	var mission models.ClassMission
	if err := c.Bind(&mission); err != nil {
		return err
	}
	mission.ID = 0

	err := c.Tx.Create(&mission)
	if err != nil {
		return err
	}
	return c.NoContent(201)
}

func (a *AdminTeacher) PutMission(c *models.Context) error {
	var mission models.ClassMission
	if err := c.Bind(&mission); err != nil {
		return err
	}

	id, err := strconv.Atoi(c.Param("missionid"))
	if err != nil {
		return err
	}

	mission.ID = id
	err = mission.Update()
	if err != nil {
		return err
	}
	return c.NoContent(201)
}

func (a *AdminTeacher) DeleteMission(c *models.Context) error {
	id, err := strconv.Atoi(c.Param("missionid"))
	if err != nil {
		return err
	}

	mission, err := models.Tx(c.Tx).GetMission(id)
	if err != nil {
		return err
	}
	err = mission.Destroy()
	if err != nil {
		return err
	}
	return c.NoContent(200)
}

func (a *AdminTeacher) GetBook(c *models.Context) error {
	id, err := strconv.Atoi(c.Param("bookid"))
	if err != nil {
		return err
	}

	book, err := models.Tx(c.Tx).GetBook(id)
	if err != nil {
		return err
	}

	return c.JSON(200, book)
}
