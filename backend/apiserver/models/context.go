package models

import (
	"gorani/models/dbmodels"

	"github.com/sunho/pop"
	"github.com/labstack/echo"
)

type Context struct {
	echo.Context
	User         dbmodels.User
	BookParam    dbmodels.Book
	MemoryParam  dbmodels.Memory
	PostParam    dbmodels.Post
	CommentParam dbmodels.PostComment
	Tx           *pop.Connection
}
