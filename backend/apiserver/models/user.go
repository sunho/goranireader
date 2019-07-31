//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package models

import (
	"encoding/json"
	"errors"
	"time"

	"golang.org/x/oauth2"

	"github.com/gofrs/uuid"
	"github.com/sunho/webf/wfdb"

	"github.com/gobuffalo/nulls"
)

type User struct {
	wfdb.DefaultModel `db:"-"`
	ID                int       `db:"id" json:"id"`
	ClassID           nulls.Int `db:"class_id" json:"class_id"`
	OauthID           string    `db:"oauth_id" json:"-"`
	CreatedAt         time.Time `db:"created_at" json:"-"`
	UpdatedAt         time.Time `db:"updated_at" json:"-"`
	Username          string    `db:"username" json:"username"`
	Profile           string    `db:"profile" json:"profile"`
	Email             string    `db:"email" json:"-"`
}

func (u *User) GetToken() (*oauth2.Token, error) {
	var tok UserToken
	err := u.Tx().Q().Where("user_id = ?", u.ID).First(&tok)
	if err != nil {
		return nil, err
	}

	var out oauth2.Token
	err = json.Unmarshal([]byte(tok.Buf), &out)
	if err != nil {
		return nil, err
	}
	return &out, nil
}

func (u *User) SetToken(tok *oauth2.Token) error {
	buf, err := json.Marshal(tok)
	if err != nil {
		return err
	}

	err = u.Tx().Upsert(&UserToken{
		UserID: u.ID,
		Buf:    string(buf),
	})
	if err != nil {
		return err
	}
	return nil
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

func (u *User) GetBookProgress(bookid int) (*UserBookProgress, error) {
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
			Profile:  u.Profile,
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
		Profile:  u.Profile,
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
