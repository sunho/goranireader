//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package utils

import (
	"net/http"
	"time"
)

func CreateClient() http.Client {
	return http.Client{
		Timeout: time.Second * 10,
	}
}
