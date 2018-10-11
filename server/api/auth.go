package api

import "github.com/labstack/echo"

func (a *API) login(c *echo.Context) error {
	username := c.FromValue("username")
	password := c.FromValue("password")
	a.
}
