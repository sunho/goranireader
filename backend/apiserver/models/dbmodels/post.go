//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package dbmodels

import (
	"time"

	"github.com/gobuffalo/nulls"
	"github.com/gofrs/uuid"
)

type Post struct {
	ID        int       `db:"id" json:"id"`
	UserID    int       `db:"user_id" json:"user_id"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
}

type PostComment struct {
	ID        int       `db:"id" json:"id"`
	UserID    int       `db:"user_id" json:"user_id"`
	PostID    int       `db:"post_id" json:"post_id"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
	Content   string    `db:"content" json:"content"`
}

type SentencePost struct {
	ID             int          `db:"id" json:"id"`
	BookID         int          `db:"book_id" json:"book_id"`
	TopContent     string       `db:"top_content" json:"top_content"`
	Sentence       string       `db:"sentence" json:"sentence"`
	BottomContent  string       `db:"bottom_content" json:"bottom_content"`
	Solved         bool         `db:"solved" json:"solved"`
	SolvingContent nulls.String `db:"solving_content" json:"solving_content"`
	SolvingComment nulls.Int    `db:"solving_comment" json:"solving_comment"`
}

type DetailedSentencePost struct {
	ID             int          `db:"id" json:"id"`
	UserID         int          `db:"user_id" json:"user_id"`
	CreatedAt      time.Time    `db:"created_at" json:"created_at"`
	UpdatedAt      time.Time    `db:"updated_at" json:"updated_at"`
	BookID         int          `db:"book_id" json:"book_id"`
	TopContent     string       `db:"top_content" json:"top_content"`
	Sentence       string       `db:"sentence" json:"sentence"`
	BottomContent  string       `db:"bottom_content" json:"bottom_content"`
	Solved         bool         `db:"solved" json:"solved"`
	SolvingContent nulls.String `db:"solving_content" json:"solving_content"`
	SolvingComment nulls.Int    `db:"solving_comment" json:"solving_comment"`
	Rate           nulls.Int    `db:"rate" json:"rate"`
	CommentCount   nulls.Int    `db:"comment_count" json:"comment_count"`
}

func (p *DetailedSentencePost) Split() (Post, SentencePost) {
	return Post{
			ID:        p.ID,
			UserID:    p.UserID,
			CreatedAt: p.CreatedAt,
			UpdatedAt: p.UpdatedAt,
		},
		SentencePost{
			ID:             p.ID,
			BookID:         p.BookID,
			TopContent:     p.TopContent,
			Sentence:       p.Sentence,
			BottomContent:  p.BottomContent,
			Solved:         p.Solved,
			SolvingComment: p.SolvingComment,
		}
}

type DetailedPostComment struct {
	ID        int       `db:"id" json:"id"`
	UserID    int       `db:"user_id" json:"user_id"`
	PostID    int       `db:"post_id" json:"post_id"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
	Content   string    `db:"content" json:"content"`
	Rate      nulls.Int `db:"rate" json:"rate"`
}

type FeedPost struct {
	ID        uuid.UUID `db:"id"`
	UserID    int       `db:"user_id"`
	PostID    int       `db:"post_id"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
}
