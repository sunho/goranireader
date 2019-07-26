//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package models

import (
	"gorani/models/dbmodels"

	"github.com/labstack/echo"
	"github.com/sunho/pop"
)

type Context struct {
	echo.Context
	User        dbmodels.User
	BookParam   dbmodels.Book
	MemoryParam dbmodels.Memory
	Tx          *pop.Connection
}
