package server

import (
	"github.com/labstack/echo"
	"go.uber.org/dig"
)

type Server struct {
	addr string
	e    *echo.Echo
	c    *dig.Container
}

func New(addr string, c *dig.Container) *Server {
	s := &Server{
		addr: addr,
		e:    echo.New(),
		c:    c,
	}
	s.register()
	return s
}

func (s *Server) Listen() error {
	return s.e.Start(s.addr)
}

func (s *Server) register() {
	routes := &Routes{}
	routes.setup(s.c)
	routes.register(s.e)
}
