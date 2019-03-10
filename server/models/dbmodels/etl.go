package dbmodels

import "time"

type SimilarWord struct {
	Word        string `db:"word"`
	Type        string `db:"type"`
	Similarity  int    `db:"similarity"`
	SimilarWord string `db:"similar_word"`
}

type RecommendBook struct {
	UserID    int       `db:"user_id"`
	BookID    int       `db:"book_id"`
	CreatedAt time.Time `db:"created_at"`
	UpdatedAt time.Time `db:"updated_at"`
	Cause     string    `db:"cause"`
}

type ReadableBook struct {
	UserID int `db:"user_id"`
	BookID int `db:"book_id"`
}
