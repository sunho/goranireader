//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package models

import (
	"encoding/json"
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

type UserToken struct {
	wfdb.DefaultModel `db:"-"`
	ID                uuid.UUID `db:"id"`
	UserID            int       `db:"user_id" pk:"true"`
	Buf               string    `db:"buf"`
}
