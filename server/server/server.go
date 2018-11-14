package server

import (
	"github.com/labstack/echo"
	"go.uber.org/dig"
)

type Server struct {
	e *echo.Echo
	c *dig.Container
}

func New(c *dig.Container) *Server {
	s := &Server{
		e: echo.New(),
		c: c,
	}
	return s
}

func (s *Server) register() {
	routes := &Routes{}
	routes.setup(s.c)
	routes.register(s.e)
}