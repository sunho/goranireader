//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package dbmodels

import (
	"time"

	"github.com/gofrs/uuid"
)

type Rate struct {
	ID        uuid.UUID `db:"id" json:"-"`
	TargetID  int       `db:"target_id" pk:"true" json:"-"`
	Kind      string    `db:"kind" pk:"true" json:"-"`
	UserID    int       `db:"user_id" pk:"true" json:"-"`
	CreatedAt time.Time `db:"created_at" json:"-"`
	UpdatedAt time.Time `db:"updated_at" json:"-"`
	Rate      float64   `db:"rate" json:"rate"`
}
