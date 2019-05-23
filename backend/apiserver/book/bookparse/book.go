//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package bookparse

import (
	"gorani/book/sentencer"
	"io"
)

type (
	Book struct {
		Isbn      string
		Name      string
		Author    string
		Cover     Cover
		Genre     []string
		Sentences []sentencer.Sentence
	}

	Cover struct {
		Reader io.Reader
		Ext    string
	}
)
