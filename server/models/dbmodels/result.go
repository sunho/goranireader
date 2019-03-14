package dbmodels

import "github.com/gofrs/uuid"

type QuizResult struct {
	ID     uuid.UUID `db:"id" json:"-"`
	UserID int       `db:"user_id" pk:"true" json:"-"`
	BookID int       `db:"book_id" pk:"true" json:"book_id"`
	QuizID int       `db:"quiz_id" pk:"true" json:"quiz_id"`
	Score  int       `db:"score" json:"score"`
}

type SensResult struct {
	ID     uuid.UUID `db:"id" json:"-"`
	UserID int       `db:"user_id" pk:"true" json:"-"`
	BookID int       `db:"book_id" pk:"true" json:"book_id"`
	SensID int       `db:"sens_id" pk:"true" json:"sens_id"`
	Score  int       `db:"score" json:"score"`
}
