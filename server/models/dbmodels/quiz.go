package dbmodels

import "github.com/gobuffalo/uuid"

type UserQuizResult struct {
	ID     uuid.UUID `db:"id"`
	UserID int       `db:"user_id"`
	BookID int       `db:"book_id"`
	Seq    int       `db:"seq"`
	Score  int       `db:"score"`
}

type UserSensResult struct {
	ID     uuid.UUID `db:"id"`
	UserID int       `db:"user_id"`
	BookID int       `db:"book_id"`
	Seq    int       `db:"seq"`
	Score  int       `db:"score"`
}
