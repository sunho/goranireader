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
	ID        uuid.UUID `db:"id"`
	UserID    int       `db:"user_id"`
	BookID    int       `db:"book_id"`
	CreatedAt time.Time `db:"created_at"`
	UpdatedAt time.Time `db:"updated_at"`
	Cause     string    `db:"cause"`
}

type RecommendBookRate struct {
	ID     uuid.UUID `db:"id"`
	UserID int       `db:"user_id"`
	BookID int       `db:"book_id"`
	Rate   int       `db:"rate"`
}

type ReadableBook struct {
	ID         uuid.UUID `db:"id"`
	UserID     int       `db:"user_id"`
	BookID     int       `db:"book_id"`
	Difficulty int       `db:"difficulty"`
}
