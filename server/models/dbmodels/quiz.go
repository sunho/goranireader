package dbmodels

type UserQuizResult struct {
	UserID int `db:"user_id"`
	BookID int `db:"book_id"`
	Seq    int `db:"seq"`
	Score  int `db:"score"`
}

type UserSensResult struct {
	UserID int `db:"user_id"`
	BookID int `db:"book_id"`
	Seq    int `db:"seq"`
	Score  int `db:"score"`
}
