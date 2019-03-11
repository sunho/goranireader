package middles

import (
	"gorani/models"

	"github.com/labstack/echo"
)

type ContextMiddle struct {
}
	
func (c *ContextMiddle) Act(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		return next(&models.Context{
			Context: c,
		})
	}
}
