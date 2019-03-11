package dbmodels

import "github.com/gofrs/uuid"

type QuizResult struct {
	ID     uuid.UUID `db:"id"`
	UserID int       `db:"user_id"`
	BookID int       `db:"book_id"`
	QuizID int       `db:"quiz_id"`
	Score  int       `db:"score"`
}

type SensResult struct {
	ID     uuid.UUID `db:"id"`
	UserID int       `db:"user_id"`
	BookID int       `db:"book_id"`
	SensID int       `db:"sens_id"`
	Score  int       `db:"score"`
}
