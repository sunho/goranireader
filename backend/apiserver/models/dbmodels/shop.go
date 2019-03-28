package dbmodels

import (
	"time"

	"github.com/gofrs/uuid"
)

type Rate struct {
	ID        uuid.UUID `db:"id"`
	TargetID  int       `db:"target_id"`
	Kind      string    `db:"kind"`
	UserID    int       `db:"user_id"`
	CreatedAt time.Time `db:"created_at"`
	Rate      float64   `db:"rate"`
}

type Review struct {
	ID         int       `db:"id"`
	BookID     int       `db:"book_id"`
	UserID     int       `db:"user_id"`
	CreeatedAt time.Time `db:"created_at"`
	Content    string    `db:"content"`
	Rate       float64   `db:"rate"`
}
