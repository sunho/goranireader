package dbserv

import (
	"github.com/labstack/echo"
	"github.com/gobuffalo/pop"
)

type DBConf struct {
	Stage string `yaml:"stage"`
}

type DBServ struct {
	*pop.Connection
}

func (c DBServ) ConfigName() string {
	return "db"
}

func Provide(conf DBConf) (*DBServ, error) {
	conn, err := pop.Connect(conf.Stage)
	if err != nil {
		return nil, err
	}
	return &DBServ{
		Connection: conn,
	},nil
}

func (db *DBServ) ReturnErrIfExists(field string, bean interface{}) error {
	exists, err := db.Q().Exists(bean)
	if err != nil {
		return err
	}

	if exists {
		return echo.NewHTTPError(409, "existing resource:"+field)
	}
	return nil
}

func (db *DBServ) ReturnErrIfNotExists(bean interface{}) error {
	exists, err := db.Q().Exists(bean)
	if err != nil {
		return err
	}

	if !exists {
		return echo.NewHTTPError(404, "not existing resource")
	}
	return nil
}