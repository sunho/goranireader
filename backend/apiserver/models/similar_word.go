//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package models

import (
	"github.com/sunho/webf/wfdb"
)

type SimilarWord struct {
	wfdb.DefaultModel `db:"-"`
	Word              string `json:"word"`
	Score             int    `json:"score"`
}
