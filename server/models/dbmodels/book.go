package dbmodels

import (
	"time"

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
	Categories  []Category   `has_many:"category"`
}

type BookEpub struct {
	BookID    int       `db:"book_id"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
	Epub      string    `db:"epub"`
}

type BookSens struct {
	BookID    int       `db:"book_id"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
	Sens      string    `db:"sens"`
}

type BookQuiz struct {
	BookID    int       `db:"book_id"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
	Quiz      string    `db:"quiz"`
}

type BookWord struct {
	BookID int    `db:"book_id"`
	Word   string `db:"word"`
	N      int    `db:"n"`
}
