package dbmodels

import (
	"time"

	"github.com/gobuffalo/nulls"

	"github.com/gofrs/uuid"
)

type User struct {
	ID        int       `db:"id" json:"id"`
	OauthID   string    `db:"oauth_id" json:"-"`
	CreatedAt time.Time `db:"created_at" json:"created_at"`
	UpdatedAt time.Time `db:"updated_at" json:"updated_at"`
	Username  string    `db:"username" json:"username"`
	Email     string    `db:"email" json:"email"`
}

type UsersBooks struct {
	ID     uuid.UUID `db:"id"`
	UserID int       `db:"user_id"`
	BookID int       `db:"book_id"`
}

type RecommendInfo struct {
	ID           uuid.UUID `db:"id" json:"-"`
	UserID       int       `db:"user_id" json:"-"`
	TargetBookID nulls.Int `db:"target_book_id" json:"target_book_id"`
}
