package models

import (
	"gorani/models/dbmodels"
	"github.com/labstack/echo"
)

type Context struct {
	echo.Context
	User dbmodels.User
}
