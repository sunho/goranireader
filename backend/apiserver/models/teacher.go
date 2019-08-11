package models

import (
	"time"

	"github.com/sunho/webf/wfdb"
)

type Admin struct {
	wfdb.DefaultModel `db:"-"`
	ID                int       `db:"id" json:"id"`
	CreatedAt         time.Time `db:"created_at" json:"created_at"`
	UpdatedAt         time.Time `db:"updated_at" json:"updated_at"`
}

type Class struct {
	wfdb.DefaultModel `db:"-"`
	ID                int       `db:"id" json:"id"`
	Name              string    `db:"name" json:"name"`
	CreatedAt         time.Time `db:"created_at" json:"created_at"`
	UpdatedAt         time.Time `db:"updated_at" json:"updated_at"`
}

func (c *Class) GetMissions() ([]ClassMission, error) {
	out := []ClassMission{}
	err := c.Tx().Q().Where("class_id = ?", c.ID).All(&out)
	return out, err
}

func (c *Class) GetCurrentMission() (*ClassMission, error) {
	var out ClassMission
	err := c.Tx().Q().Where("class_id = ? AND start_at < ? AND end_at > ?",
		c.ID, time.Now().UTC(), time.Now().UTC()).First(&out)
	return &out, err
}

func (c *Class) GetUsers() ([]User, error) {
	out := []User{}
	err := c.Tx().Q().Where("class_id = ?", c.ID).All(&out)
	if err != nil {
		return nil, err
	}
	return out, nil
}

type ClassMission struct {
	wfdb.DefaultModel `db:"-"`
	ID                int       `db:"id" json:"id"`
	ClassID           int       `db:"class_id" json:"class_id"`
	BookID            string    `db:"book_id" json:"book_id"`
	CreatedAt         time.Time `db:"created_at" json:"created_at"`
	UpdatedAt         time.Time `db:"updated_at" json:"updated_at"`
	StartAt           time.Time `db:"start_at" json:"start_at"`
	EndAt             time.Time `db:"end_at" json:"end_at"`
}

func (c *ClassMission) IsActive(t time.Time) bool {
	return t.After(c.StartAt) && t.Before(c.EndAt)
}

func (c *ClassMission) IsOverlap(m *ClassMission) bool {
	return c.StartAt.Before(m.EndAt) || c.EndAt.After(m.StartAt)
}
