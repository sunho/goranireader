package dbmodels

import (
	"database/sql/driver"
	"encoding/json"
	"errors"

	"github.com/gobuffalo/uuid"
)

type Word struct {
	ID   uuid.UUID `db:"id"`
	Word string    `db:"word"`
}

type UnknownWord struct {
	ID          uuid.UUID          `db:"id"`
	UserID      int                `db:"user_id"`
	Word        string             `db:"word"`
	Definitions UnknownDefinitions `db:"definitions"`
}

type UnknownDefinitions []UnknownDefinition

func (s *UnknownDefinitions) Value() (driver.Value, error) {
	str, err := json.Marshal(s)
	if err != nil {
		return nil, err
	}
	return driver.Value(str), nil
}

func (s *UnknownDefinitions) Scan(i interface{}) error {
	var src []byte
	switch i.(type) {
	case string:
		src = []byte(i.(string))
	case []byte:
		src = i.([]byte)
	default:
		return errors.New("Incompatible type for Cord")
	}
	return json.Unmarshal(src, s)
}

type UnknownDefinition struct {
	Definition string           `json:"definition"`
	Examples   []UnknownExample `json:"examples"`
}

type UnknownExample struct {
	Setnence string `json:"sentence"`
	Index    int    `json:"index"`
	Book     string `json:"book"`
}

type Memory struct {
	ID       int    `db:"id"`
	UserID   int    `db:"user_id"`
	Word     string `db:"word"`
	Sentence string `db:"sentence"`
}

type MemoryRate struct {
	ID       uuid.UUID `db:"id"`
	MemoryID int       `db:"memory_id"`
	UserID   int       `db:"user_id"`
	Rate     int       `db:"rate"`
}

type KnownWord struct {
	ID     uuid.UUID `db:"id"`
	UserID int       `db:"user_id"`
	Word   string    `db:"word"`
	N      int       `db:"n"`
}
