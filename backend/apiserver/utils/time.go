//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package utils

import "time"

func RoundTime(t time.Time) time.Time {
	return time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, t.Location())
}
