package dbmodels

import (
	"time"

	"github.com/gofrs/uuid"
)

type User struct {
	ID           int       `db:"id"`
	CreatedAt    time.Time `db:"created_at"`
	UpdatedAt    time.Time `db:"updated_at"`
	Username     string    `db:"username"`
	Email        string    `db:"email"`
	PasswordHash string    `db:"password_hash"`
}

type UsersBooks struct {
	ID     uuid.UUID `db:"id"`
	UserID int       `db:"user_id"`
	BookID int       `db:"book_id"`
}

type UserInfo struct {
	UserID int `db:"user_id"`
}

type RecommendInfo struct {
	ID           uuid.UUID  `db:"id"`
	UserID       int        `db:"user_id"`
	TargetBookID int        `db:"target_book_id"`
	Categories   []Category `many_to_many:"category"`
}
