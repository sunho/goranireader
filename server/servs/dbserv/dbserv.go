package dbserv

import (
	"github.com/labstack/echo"
	"github.com/gobuffalo/pop"
)

type DBServ struct {
	*pop.Connection
}

func Provide() (*DBServ, error) {
	conn, err := pop.Connect("gorani")
	if err != nil {
		return nil, err
	}
	return &DBServ{
		Connection: conn,
	},nil
}

func (db *DBServ) Init() error {
	mig, err := pop.NewFileMigrator("migrations", db.Connection)
	if err != nil {
		return err
	}
	
	return mig.Up()
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