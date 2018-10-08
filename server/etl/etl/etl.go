package etl

import (
	"github.com/sunho/gorani-reader-server/go/pkg/gorani"
)

type Etl struct {
	*gorani.Gorani
	Config Config
}

func New(gorn *gorani.Gorani, conf Config) (*Etl, error) {
	e := &Etl{
		Gorani: gorn,
		Config: conf,
	}
	e.Config.Config = gorn.Config

	err := e.ReloadSentencer()
	if err != nil {
		return nil, err
	}

	return e, nil
}
