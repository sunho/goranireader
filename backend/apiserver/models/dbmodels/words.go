package dbmodels

type Memory struct {
	ID       int    `db:"id" json:"id"`
	UserID   int    `db:"user_id" pk:"true" json:"user_id"`
	Word     string `db:"word" pk:"true" json:"-"`
	Sentence string `db:"sentence" json:"sentence"`
	Rate     int    `db:"rate" json:"rate"`
}
