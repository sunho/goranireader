package bookfetch

import (
	"io"

	"gorani/sentencer"
)

type (
	Book struct {
		Isbn      string
		Name      string
		Author    string
		Cover     Cover
		Genre     []string
		Sentences []sentencer.Sentence
		Ratings   []BookRating
		Reviews   []BookReview
	}

	BookRating struct {
		Provider string
		Number   string
		Rating   float32
	}

	BookReview struct {
		Provider string
		Comment  string
	}

	Cover struct {
		Reader io.Reader
		Ext    string
		Object string
	}
)
