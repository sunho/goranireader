package middles

import (
	"github.com/labstack/echo/middleware"

	"github.com/labstack/echo"
)

type LoggerMiddle struct {
}

func (c *LoggerMiddle) Act(next echo.HandlerFunc) echo.HandlerFunc {
	return middleware.Logger()(next)
}
