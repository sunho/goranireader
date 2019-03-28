package dbmodels

import (
	"gorani/utils"
	"time"

	"github.com/gofrs/uuid"
)

type User struct {
	ID           int       `db:"id" json:"id"`
	CreatedAt    time.Time `db:"created_at" json:"created_at"`
	UpdatedAt    time.Time `db:"updated_at" json:"updated_at"`
	Username     string    `db:"username" json:"username"`
	Email        string    `db:"email" json:"email"`
	PasswordHash string    `db:"password_hash" json:"-"`
}

type UsersBooks struct {
	ID     uuid.UUID `db:"id"`
	UserID int       `db:"user_id"`
	BookID int       `db:"book_id"`
}

type RecommendInfo struct {
	ID           uuid.UUID        `db:"id" json:"-"`
	UserID       int              `db:"user_id" json:"-"`
	TargetBookID int              `db:"target_book_id" json:"target_book_id"`
	Categories   utils.SQLStrings `db:"categories" json:"categories"`
}
