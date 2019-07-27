package models

import (
	"time"

	"github.com/sunho/webf/wfdb"

	"github.com/gofrs/uuid"
)

type Class struct {
	wfdb.DefaultModel `db:"-"`
	ID                int       `db:"id" json:"id"`
	Name              string    `db:"name" json:"name"`
	CreatedAt         time.Time `db:"created_at" json:"created_at"`
	UpdatedAt         time.Time `db:"updated_at" json:"updated_at"`
}

type ClassMission struct {
	wfdb.DefaultModel `db:"-"`
	ID                int       `db:"id" json:"id"`
	ClassID           int       `db:"class_id" json:"class_id"`
	Pages             int       `db:"pages" json:"pages"`
	CreatedAt         time.Time `db:"created_at" json:"created_at"`
	UpdatedAt         time.Time `db:"updated_at" json:"updated_at"`
	StartAt           time.Time `db:"start_at" json:"start_at"`
	EndAt             time.Time `db:"end_at" json:"end_at"`
}

type UserMissionProgress struct {
	wfdb.DefaultModel `db:"-"`
	ID                uuid.UUID `db:"id" json:"-"`
	UserID            int       `db:"user_id" json:"-" pk:"true"`
	MissionID         int       `db:"mission_id" json:"-" pk:"true"`
	ReadPages         int       `db:"read_pages" json:"read_pages"`
	CreatedAt         time.Time `db:"created_at" json:"-"`
	UpdatedAt         time.Time `db:"updated_at" json:"-"`
}
