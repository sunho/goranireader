package dbmodels

import (
	"time"

	"github.com/gofrs/uuid"
)

type Class struct {
	ID        int       `db:"id" json:"id"`
	Name      string    `db:"name" json:"name"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
}

type Mission struct {
	ID        int       `db:"id" json:"id"`
	ClassID   int       `db:"class_id" json:"class_id"`
	Pages     int       `db:"page" json:"page"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
	StartAt   time.Time `db:"start_at" json:"start_at"`
	EndAt     time.Time `db:"end_at" json:"end_at"`
}

type MissionProgress struct {
	ID        uuid.UUID `db:"id" json:"id"`
	UserID    int       `db:"user_id" json:"user_id"`
	MissionID int       `db:"mission_id" json:"mission_id"`
	ReadPages int       `db:"read_pages" json:"read_pages"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
}
