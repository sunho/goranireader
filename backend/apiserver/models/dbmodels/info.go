package dbmodels

import (
	"time"

	"github.com/gobuffalo/nulls"
	"github.com/gofrs/uuid"
)

type TotalRate struct {
	ID   int     `db:"id"`
	Type string  `db:"type"`
	Rate float64 `db:"rate"`
}

type SimilarWord struct {
	ID          uuid.UUID `db:"id"`
	Word        string    `db:"word"`
	Type        string    `db:"type"`
	Similarity  int       `db:"similarity"`
	SimilarWord string    `db:"similar_word"`
}

type RecommendedBook struct {
	ID        uuid.UUID `db:"id" json:"-"`
	UserID    int       `db:"user_id" json:"-"`
	BookID    int       `db:"book_id" json:"book_id"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
}

type DetailedRecommendedBook struct {
	ID        uuid.UUID `db:"id" json:"-"`
	UserID    int       `db:"user_id" json:"-"`
	BookID    int       `db:"book_id" json:"book_id"`
	Rate      nulls.Int `db:"rate" json:"rate"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
}

type ReadableBook struct {
	ID         uuid.UUID `db:"id"`
	UserID     int       `db:"user_id"`
	BookID     int       `db:"book_id"`
	Difficulty int       `db:"difficulty"`
}

type TargetBookProgress struct {
	ID uuid.UUID `db:"id" json:"-"`
	UserID int `db:"user_id" json:"-"`
	BookID int `db:"book_id" json:"-"`
	Progress float64 `db:"progress" json:"progress"`
}