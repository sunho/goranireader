package dbmodels

import "github.com/gofrs/uuid"

type QuizProgress struct {
	ID     uuid.UUID `db:"id"`
	UserID int       `db:"user_id"`
	BookID int       `db:"book_id"`
	QuizID int       `db:"quiz_id"`
}

type SensProgress struct {
	ID     uuid.UUID `db:"id"`
	UserID int       `db:"user_id"`
	BookID int       `db:"book_id"`
	SensID int       `db:"sens_id"`
}
