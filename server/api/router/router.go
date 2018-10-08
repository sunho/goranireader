package router

import (
	"github.com/go-chi/chi"
	"github.com/sunho/gorani-reader-server/go/api/api"
)

type Router struct {
	chi.Router
	ap *api.Api
}

func New(ap *api.Api) *Router {
	r := &Router{
		Router: chi.NewRouter(),
		ap:     ap,
	}
	r.registerHandlers()

	return r
}
