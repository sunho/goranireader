//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package models

import (
	"errors"
	"time"

	"github.com/gofrs/uuid"
	"github.com/sunho/webf/wfdb"

	"github.com/gobuffalo/nulls"
)

type User struct {
	wfdb.DefaultModel `db:"-"`
	ID                int       `db:"id" json:"id"`
	Username          string    `db:"username" json:"username"`
	ClassID           nulls.Int `db:"class_id" json:"class_id"`
	SecretCode        string    `db:"secret_code" json:"secret_code"`
	CreatedAt         time.Time `db:"created_at" json:"-"`
	UpdatedAt         time.Time `db:"updated_at" json:"-"`
}

func (u *User) GetClass() (*Class, error) {
	if !u.ClassID.Valid {
		return nil, errors.New("No class")
	}
	var out Class
	err := u.Tx().Q().Where("id = ?", u.ClassID.Int).First(&out)
	if err != nil {
		return nil, err
	}
	return &out, nil
}

func (u *User) GetBookProgress(bookid string) (*UserBookProgress, error) {
	var out UserBookProgress
	err := u.Tx().Q().Where("user_id = ? AND book_id = ?", u.ID, bookid).First(&out)
	if err != nil {
		return &UserBookProgress{
			ReadPages: 0,
		}, nil
	}
	return &out, err
}

type StudentView struct {
	ID       int     `json:"id"`
	Name     string  `json:"name"`
	Profile  string  `json:"profile"`
	Progress float32 `json:"progress"`
}

func (u *User) GetStudentView() (StudentView, error) {
	class, err := u.GetClass()
	if err != nil {
		return StudentView{}, err
	}
	mission, err := class.GetCurrentMission()
	if err != nil {
		return StudentView{
			ID:       u.ID,
			Name:     u.Username,
			Progress: 0,
		}, nil
	}
	progress, err := u.GetBookProgress(mission.BookID)
	if err != nil {
		return StudentView{}, err
	}

	// TODO
	return StudentView{
		ID:       u.ID,
		Name:     u.Username,
		Progress: float32(progress.ReadPages) / 1000.0,
	}, nil
}

type UserToken struct {
	wfdb.DefaultModel `db:"-"`
	ID                uuid.UUID `db:"id"`
	UserID            int       `db:"user_id" pk:"true"`
	Buf               string    `db:"buf"`
}

type UserBookProgress struct {
	wfdb.DefaultModel `db:"-"`
	ID                uuid.UUID `db:"id" json:"-"`
	UserID            int       `db:"user_id" json:"-" pk:"true"`
	BookID            int       `db:"book_id" json:"-" pk:"true"`
	ReadPages         int       `db:"read_pages" json:"read_pages"`
	CreatedAt         time.Time `db:"created_at" json:"-"`
	UpdatedAt         time.Time `db:"updated_at" json:"-"`
}
