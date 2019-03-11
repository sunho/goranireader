package dbmodels

import (
	"time"

	"github.com/gofrs/uuid"

	"github.com/gobuffalo/nulls"
)

type Book struct {
	ID          int          `db:"id" json:"id" pk:"true"`
	CreatedAt   time.Time    `db:"created_at" json:"created_at"`
	UpdatedAt   time.Time    `db:"updated_at" json:"updated_at"`
	ISBN        string       `db:"isbn" json:"isbn"`
	Name        string       `db:"name" json:"name"`
	NativeName  nulls.String `db:"native_name" json:"native_name"`
	Cover       string       `db:"cover" json:"cover"`
	Description string       `db:"description" json:"description"`
	Epub        BookEpub     `has_one:"book_epub" json:"epub"`
	Sens        BookSens     `has_one:"book_sens" json:"sens"`
	Quiz        BookQuiz     `has_one:"book_quiz" json:"quiz"`
	Rate        int          `db:"rate" json:"rate"`
	Categories  []Category   `many_to_many:"books_categories" json:"categories"`
}

type BookEpub struct {
	ID        uuid.UUID    `db:"id" json:"-"`
	BookID    int          `db:"book_id" pk:"true" json:"-"`
	CreatedAt time.Time    `db:"created_at" json:"created_at"`
	UpdatedAt time.Time    `db:"updated_at" json:"updated_at"`
	Epub      nulls.String `db:"epub" json:"epub"`
}

type BookSens struct {
	ID        uuid.UUID    `db:"id" json:"-"`
	BookID    int          `db:"book_id" pk:"true" json:"-"`
	CreatedAt time.Time    `db:"created_at" json:"created_at"`
	UpdatedAt time.Time    `db:"updated_at" json:"updated_at"`
	Sens      nulls.String `db:"sens" json:"sens"`
}

type BookQuiz struct {
	ID        uuid.UUID    `db:"id" json:"-"`
	BookID    int          `db:"book_id" pk:"true" json:"-"`
	CreatedAt time.Time    `db:"created_at" json:"created_at"`
	UpdatedAt time.Time    `db:"updated_at" json:"updated_at"`
	Quiz      nulls.String `db:"quiz" json:"quiz"`
}

type BookWord struct {
	ID     uuid.UUID `db:"id"`
	BookID int       `db:"book_id"`
	Word   string    `db:"word"`
	N      int       `db:"n"`
}
