package dbmodels

import "github.com/gofrs/uuid"

type Category struct {
	ID   int    `db:"id" json:"id"`
	Name string `db:"name" json:"name"`
}

type Review struct {
	ID      int    `db:"id" json:"id"`
	BookID  int    `db:"book_id" json:"book_id"`
	UserID  int    `db:"user_id" json:"user_id"`
	Content string `db:"content" json:"content"`
	Rate    int    `db:"rate" json:"rate'`
}

type ReviewRate struct {
	ID       uuid.UUID `db:"id" json:"-"`
	ReviewID int       `db:"review_id" json:"-"`
	UserID   int       `db:"user_id" json:"-"`
	Rate     int       `db:"rate" json:"rate"`
}
