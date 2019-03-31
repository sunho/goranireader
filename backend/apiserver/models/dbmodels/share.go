package dbmodels

import "time"

type Share struct {
	ID            int       `db:"id"`
	UserID        int       `db:"user_id"`
	UpParagraph   string    `db:"up_paragraph"`
	DownParagraph string    `db:"down_paragraph"`
	Sentence      string    `db:"sentence"`
	CreatedAt     time.Time `db:"created_at"`
}

type ShareComment struct {
	ID        int       `db:"id"`
	ShareID   int       `db:"share_id"`
	UserID    int       `db:"user_id"`
	Content   string    `db:"content"`
	Rate      int       `db:"rate"`
	CreatedAt time.Time `db:"created_at"`
}
