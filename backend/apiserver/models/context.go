//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package models

import (
	"github.com/sunho/webf"

	"github.com/labstack/echo"
)

type Context struct {
	*webf.DefaultContext
	User        *User
	ClassParam  *Class
	BookParam   Book
	MemoryParam Memory
}

func NewContext(c echo.Context) webf.Context {
	return &Context{
		DefaultContext: webf.NewDefaultContext(c),
	}
}
