package middles

import (
	"github.com/gobuffalo/pop"
	"gorani/models"
	"gorani/servs/dbserv"

	"github.com/labstack/echo"
)

type TxMiddle struct {
	DB *dbserv.DBServ `dim:"on"`
}
func (t *TxMiddle) Act(next echo.HandlerFunc) echo.HandlerFunc {
	return func(c2 echo.Context) error {
		return t.DB.Transaction(func(tx *pop.Connection) error {
			c := c2.(*models.Context)
			c.Tx = tx
			return next(c)
		})
	}
}
