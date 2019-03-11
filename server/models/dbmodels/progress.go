package dbmodels

import "github.com/gofrs/uuid"

type QuizProgress struct {
	ID     uuid.UUID `db:"id" json:"-"`
	UserID int       `db:"user_id" pk:"true" json:"-"`
	BookID int       `db:"book_id" pk:"true" json:"-"`
	QuizID int       `db:"quiz_id" json:"quiz_id"`
}

type SensProgress struct {
	ID     uuid.UUID `db:"id" json:"-"`
	UserID int       `db:"user_id" pk:"true" json:"-"`
	BookID int       `db:"book_id" pk:"true" json:"-"`
	SensID int       `db:"sens_id" json:"sens_id"`
}
