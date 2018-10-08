package dbh

import (
	"github.com/jinzhu/gorm"
)

type KnownWord struct {
	UserId int `gorm:"column:user_id"`
	WordId int `gorm:"column:word_id"`
	Number int `gorm:"column:known_word_number"`
}

func (KnownWord) TableName() string {
	return "known_word"
}

func (u *User) AddKnownWords(db *gorm.DB, ids []int) (err error) {
	tx := db.Begin()
	defer func() {
		if err == nil {
			tx.Commit()
		} else {
			tx.Rollback()
		}
	}()

	for _, id := range ids {
		err = u.AddKnownWord(tx, id)
		if err != nil {
			return
		}
	}
	return
}

func (u *User) AddKnownWord(db *gorm.DB, id int) error {
	err := db.Exec(`
		INSERT INTO known_word 
			(user_id, word_id, known_word_number)
		VALUES
			(?, ?, 1) 
		ON DUPLICATE KEY UPDATE 
			known_word_number = known_word_number + 1;`,
		u.Id, id).Error
	return err
}

func (u *User) GetKnownWords(db *gorm.DB, minnum int) (words []KnownWord, err error) {
	err = db.
		Where("user_id = ? AND known_word_number >= ?", u.Id, minnum).
		Find(&words).Error
	return
}
