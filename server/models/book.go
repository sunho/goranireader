package models

import "time"

type Book struct {
	ID        int       `db:"id" json:"id"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
	Name      string    `db:"name" json:"name"`
	Epub      string    `db:"epub" json:"epub"`
	Img       string    `db:"img" json:"img"`
}
