//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package models

import (
	"gorani/utils"
	"time"

	"github.com/sunho/webf/wfdb"

	"github.com/gofrs/uuid"

	"github.com/gobuffalo/nulls"
)

type Book struct {
	wfdb.DefaultModel `db:"-"`
	ID                int              `db:"id" json:"id" pk:"true"`
	GoogleID          string           `db:"google_id" json:"google_id"`
	CreatedAt         time.Time        `db:"created_at" json:"created_at"`
	UpdatedAt         time.Time        `db:"updated_at" json:"updated_at"`
	Description       string           `db:"description" json:"description"`
	ISBN              string           `db:"isbn" json:"isbn"`
	Name              string           `db:"name" json:"name"`
	NativeName        nulls.String     `db:"native_name" json:"native_name"`
	Author            string           `db:"author" json:"author"`
	Cover             string           `db:"cover" json:"cover"`
	Epub              BookEpub         `has_one:"book_epub" json:"epub"`
	Categories        utils.SQLStrings `db:"categories" json:"categories"`
}

type BookEpub struct {
	wfdb.DefaultModel `db:"-"`
	ID                uuid.UUID    `db:"id" json:"-"`
	BookID            int          `db:"book_id" pk:"true" json:"-"`
	CreatedAt         time.Time    `db:"created_at" json:"created_at"`
	UpdatedAt         time.Time    `db:"updated_at" json:"updated_at"`
	Epub              nulls.String `db:"epub" json:"epub"`
}

func (b BookEpub) MarshalJSON() ([]byte, error) {
	if !b.Epub.Valid {
		return []byte("null"), nil
	}
	return []byte("\"" + b.Epub.String + "\""), nil
}
