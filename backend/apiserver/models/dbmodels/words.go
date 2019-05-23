//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package dbmodels

import "github.com/gobuffalo/nulls"

type Memory struct {
	ID       int    `db:"id" json:"id"`
	UserID   int    `db:"user_id" pk:"true" json:"user_id"`
	Word     string `db:"word" pk:"true" json:"-"`
	Sentence string `db:"sentence" json:"sentence"`
}

type DetailedMemory struct {
	ID       int           `db:"id" json:"id"`
	UserID   int           `db:"user_id" pk:"true" json:"user_id"`
	Word     string        `db:"word" pk:"true" json:"-"`
	Sentence string        `db:"sentence" json:"sentence"`
	Rate     nulls.Float64 `db:"rate" json:"rate"`
}
