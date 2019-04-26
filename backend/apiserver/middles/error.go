package middles

import (
	"strings"
	"strconv"
	"github.com/labstack/echo"
	"go.uber.org/zap"
	"gorani/utils"
)

type ErrorMiddle struct {
}
	
func (c *ErrorMiddle) Act(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c echo.Context) error {
		err := next(c)
		if err == nil {
			return nil
		}
		utils.Log.Error("Error in http handler", zap.Error(err))
		switch err.(type) {
		case *echo.HTTPError:
			return err
		case *strconv.NumError:
			return echo.NewHTTPError(400, "Bad request")
		default:
			switch err {
				default:
				if strings.Contains(err.Error(), "no rows in result") {
					return echo.NewHTTPError(404, "No such resource")
				}
				return echo.NewHTTPError(500)
			}
		}
	}
}

