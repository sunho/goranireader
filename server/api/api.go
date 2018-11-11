package api

import "github.com/labstack/echo"

type API struct {
	e *echo.Echo
}

func New() *API {
	a := &API{}
	a.register()
	return a
}
