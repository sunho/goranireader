//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package models

import (
	"time"

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
