package dbmodels

import "github.com/gofrs/uuid"

type Category struct {
	ID   int    `db:"id"`
	Name string `db:"name"`
}

type Review struct {
	ID      int    `db:"id"`
	BookID  int    `db:"book_id"`
	UserID  int    `db:"user_id"`
	Content string `db:"content"`
	Rate    int    `db:"rate"`
}

type ReviewRate struct {
	ID       uuid.UUID `db:"id"`
	ReviewID int       `db:"review_id"`
	UserID   int       `db:"user_id"`
	Rate     int       `db:"rate"`
}
