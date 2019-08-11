//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package models

import (
	"time"

	"github.com/sunho/webf/wfdb"
)

type Book struct {
	wfdb.DefaultModel `db:"-"`
	ID                string    `db:"id" json:"id" pk:"true"`
	CreatedAt         time.Time `db:"created_at" json:"created_at"`
	UpdatedAt         time.Time `db:"updated_at" json:"updated_at"`
	Name              string    `db:"name" json:"name"`
	Author            string    `db:"author" json:"author"`
	Cover             string    `db:"cover" json:"cover"`
	DownloadLink      string    `db:"download_link" json:"download_link"`
}
