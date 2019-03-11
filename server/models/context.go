package models

import (
	"gorani/models/dbmodels"

	"github.com/gobuffalo/pop"
	"github.com/labstack/echo"
)

type Context struct {
	echo.Context
	User        dbmodels.User
	BookParam   dbmodels.Book
	ReviewParam dbmodels.Review
	Tx          *pop.Connection
}
