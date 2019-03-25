package dbmodels

import "github.com/gofrs/uuid"

type SensProgress struct {
	ID     uuid.UUID `db:"id" json:"-"`
	UserID int       `db:"user_id" pk:"true" json:"-"`
	BookID int       `db:"book_id" pk:"true" json:"book_id"`
	SensID int       `db:"sens_id" json:"sens_id"`
}
