package dbmodels

import (
	"gorani/utils"
	"time"

	"github.com/gofrs/uuid"

	"github.com/gobuffalo/nulls"
)

type Book struct {
	ID          int              `db:"id" json:"id" pk:"true"`
	CreatedAt   time.Time        `db:"created_at" json:"created_at"`
	UpdatedAt   time.Time        `db:"updated_at" json:"updated_at"`
	Description string           `db:"description" json:"description"`
	ISBN        string           `db:"isbn" json:"isbn"`
	Name        string           `db:"name" json:"name"`
	NativeName  nulls.String     `db:"native_name" json:"native_name"`
	Author      string           `db:"author" json:"author"`
	Cover       string           `db:"cover" json:"cover"`
	Epub        BookEpub         `has_one:"book_epub" json:"epub"`
	Sens        BookSens         `has_one:"book_sens" json:"sens"`
	Rate        float64          `db:"rate" json:"rate"`
	Categories  utils.SQLStrings `db:"categories" json:"categories"`
}

type BookEpub struct {
	ID        uuid.UUID    `db:"id" json:"-"`
	BookID    int          `db:"book_id" pk:"true" json:"-"`
	CreatedAt time.Time    `db:"created_at" json:"created_at"`
	UpdatedAt time.Time    `db:"updated_at" json:"updated_at"`
	Epub      nulls.String `db:"epub" json:"epub"`
}

func (b BookEpub) MarshalJSON() ([]byte, error) {
	if !b.Epub.Valid {
		return []byte("null"), nil
	}
	return []byte("\"" + b.Epub.String + "\""), nil
}

type BookSens struct {
	ID        uuid.UUID    `db:"id" json:"-"`
	BookID    int          `db:"book_id" pk:"true" json:"-"`
	CreatedAt time.Time    `db:"created_at" json:"created_at"`
	UpdatedAt time.Time    `db:"updated_at" json:"updated_at"`
	Sens      nulls.String `db:"sens" json:"sens"`
}

func (b BookSens) MarshalJSON() ([]byte, error) {
	if !b.Sens.Valid {
		return []byte("null"), nil
	}
	return []byte("\"" + b.Sens.String + "\""), nil
}
