package dbmodels

import "time"

type User struct {
	ID           int       `db:"id"`
	CreatedAt    time.Time `db:"created_at"`
	UpdatedAt    time.Time `db:"updated_at"`
	Username     string    `db:"username"`
	Email        string    `db:"email"`
	PasswordHash string    `db:"password_hash"`
}

type UserInfo struct {
	UserID int `db:"user_id"`
}

type BookProgress struct {
}

type RecommendInfo struct {
	UserID       int        `db:"user_id"`
	TargetBookID int        `db:"target_book_id"`
	Categories   []Category `has_many:"category"`
}
