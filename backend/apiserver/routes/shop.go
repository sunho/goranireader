//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package routes

import (
	"gorani/servs/dbserv"

	"github.com/sunho/dim"
)

type Shop struct {
	DB *dbserv.DBServ `dim:"on"`
}

func (s *Shop) Register(d *dim.Group) {
	d.Route("/book", &ShopBook{})
}
