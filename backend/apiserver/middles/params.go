//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package middles

import (
	"gorani/models"
	"strconv"

	"github.com/labstack/echo"
)

// TODO: hide payload
// get Book from bookid url param
type BookParamMiddle struct {
}

func (b *BookParamMiddle) Require() []string {
	return []string{
		"ContextMiddle",
		"TxMiddle",
	}
}

func (a *BookParamMiddle) Act(c2 echo.Context) error {
	c := c2.(*models.Context)
	id, err := strconv.Atoi(c.Param("bookid"))
	if err != nil {
		return err
	}

	var book models.Book
	err = c.Tx.Eager().Where("id = ?", id).First(&book)
	if err != nil {
		return echo.NewHTTPError(404, "No such book")
	}

	c.BookParam = book

	return nil
}

type MemoryParamMiddle struct {
}

func (m *MemoryParamMiddle) Require() []string {
	return []string{
		"ContextMiddle",
		"TxMiddle",
		"AuthMiddle",
	}
}

func (m *MemoryParamMiddle) Act(c2 echo.Context) error {
	c := c2.(*models.Context)
	str := c.Param("memoryid")
	var memory models.Memory
	if str == "my" {
		err := c.Tx.Where("user_id = ? and word = ?", c.User.ID, c.Param("word")).First(&memory)
		if err != nil {
			return echo.NewHTTPError(404, "No such memory")
		}
	} else {
		id, err := strconv.Atoi(str)
		if err != nil {
			return err
		}
		err = c.Tx.Where("id = ?", id).First(&memory)
		if err != nil {
			return echo.NewHTTPError(404, "No such memory")
		}
	}
	c.MemoryParam = memory
	return nil
}
