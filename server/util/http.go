package util

import (
	"github.com/labstack/echo"
	"github.com/gobuffalo/pop"
)

func ReturnErrIfExists(conn *pop.Connection, field string, bean interface{}) error {
	exists, err := conn.Q().Exists(bean)
	if err != nil {
		return err
	}

	if exists {
		return echo.NewHTTPError(409, "existing resource:"+field)
	}
	return nil
}

func ReturnErrIfNotExists(conn *pop.Connection, bean interface{}) error {
	exists, err := conn.Q().Exists(bean)
	if err != nil {
		return err
	}

	if !exists {
		return echo.NewHTTPError(404, "not existing resource")
	}
	return nil
}
