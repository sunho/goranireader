package dbmodels

import (
	"time"

	"github.com/gobuffalo/uuid"

	"github.com/gobuffalo/pop/nulls"
)

type Book struct {
	ID          int          `db:"id" json:"id"`
	CreatedAt   time.Time    `db:"created_at" json:"created_at"`
	UpdatedAt   time.Time    `db:"updated_at" json:"updated_at"`
	ISBN        string       `db:"isbn" json:"isbn"`
	Name        string       `db:"name" json:"name"`
	NativeName  nulls.String `db:"native_name" json:"native_name"`
	Cover       string       `db:"cover" json:"cover"`
	Description string       `db:"description"`
	Epub        BookEpub     `has_one:"book_epub"`
	Sens        BookSens     `has_one:"book_sens"`
	Quiz        BookQuiz     `has_one:"book_quiz"`
	Rate        int          `db:"rate"`
	Categories  []Category   `many_to_many:"category"`
}

type BookEpub struct {
	ID        uuid.UUID    `db:"id"`
	BookID    int          `db:"book_id"`
	CreatedAt time.Time    `db:"created_at" json:"created_at"`
	UpdatedAt time.Time    `db:"updated_at" json:"updated_at"`
	Epub      nulls.String `db:"epub"`
}

type BookSens struct {
	ID        uuid.UUID    `db:"id"`
	BookID    int          `db:"book_id"`
	CreatedAt time.Time    `db:"created_at" json:"created_at"`
	UpdatedAt time.Time    `db:"updated_at" json:"updated_at"`
	Sens      nulls.String `db:"sens"`
}

type BookQuiz struct {
	ID        uuid.UUID    `db:"id"`
	BookID    int          `db:"book_id"`
	CreatedAt time.Time    `db:"created_at" json:"created_at"`
	UpdatedAt time.Time    `db:"updated_at" json:"updated_at"`
	Quiz      nulls.String `db:"quiz"`
}

type BookWord struct {
	ID     uuid.UUID `db:"id"`
	BookID int       `db:"book_id"`
	Word   string    `db:"word"`
	N      int       `db:"n"`
}
