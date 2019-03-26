package dbmodels

import "time"

type Rate struct {
	ID     int       `db:"id"`
	Kind   string    `db:"kind"`
	UserID int       `db:"user_id"`
	Time   time.Time `db:"time"`
	Rate   float64   `db:"rate"`
}
