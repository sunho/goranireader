//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package middles

import (
	"fmt"
	"gorani/models"
	"gorani/servs/authserv"

	"github.com/labstack/echo"
)

type AuthMiddle struct {
	Auth *authserv.AuthServ `dim:"on"`
}

func (a *AuthMiddle) Require() []string {
	return []string{
		"ContextMiddle",
		"TxMiddle",
	}
}

func (a *AuthMiddle) Act(c2 echo.Context) error {
	c := c2.(*models.Context)
	header := c.Request().Header.Get("Authorization")
	if header == "" {
		return echo.NewHTTPError(400, "No authorization header")
	}
	var token string
	fmt.Sscanf(header, "Bearer %s", &token)
	id, err := a.Auth.Authorize(token)
	if err != nil {
		return echo.NewHTTPError(403, "Invalid token")
	}
	var user models.User
	err = c.Tx.Where("id = ?", id).First(&user)
	if err != nil {
		return err
	}
	c.User = user
	return nil
}

type AdminAuthMiddle struct {
	Auth *authserv.AuthServ `dim:"on"`
}

func (a *AdminAuthMiddle) Require() []string {
	return []string{
		"ContextMiddle",
	}
}

func (a *AdminAuthMiddle) Act(c2 echo.Context) error {
	c := c2.(*models.Context)
	token := c.Request().Header.Get("Authorization")
	if token == "" {
		return echo.NewHTTPError(400, "No authorization header")
	}
	if a.Auth.AdminToken != token {
		return echo.NewHTTPError(403, "Invalid token")
	}
	return nil
}
