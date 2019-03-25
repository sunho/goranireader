package dbmodels

import (
	"time"

	"github.com/gofrs/uuid"
)

type SimilarWord struct {
	ID          uuid.UUID `db:"id"`
	Word        string    `db:"word"`
	Type        string    `db:"type"`
	Similarity  int       `db:"similarity"`
	SimilarWord string    `db:"similar_word"`
}

type RecommendBook struct {
	ID        uuid.UUID `db:"id" json:"-"`
	UserID    int       `db:"user_id" json:"-"`
	BookID    int       `db:"book_id" json:"book_id"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
	Cause     string    `db:"cause" json:"cause"`
}

type RecommendBookRate struct {
	ID     uuid.UUID `db:"id" json:"-"`
	UserID int       `db:"user_id" json:"-"`
	BookID int       `db:"book_id" json:"-"`
	Rate   int       `db:"rate" json:"rate"`
}

type ReadableBook struct {
	ID         uuid.UUID `db:"id"`
	UserID     int       `db:"user_id"`
	BookID     int       `db:"book_id"`
	Difficulty int       `db:"difficulty"`
}
