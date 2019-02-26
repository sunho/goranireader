package middles

import (
	"gorani/models"

	"github.com/labstack/echo"
)

func ContextMiddle(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		return next(&models.Context{
			Context: c,
		})
	}
}
