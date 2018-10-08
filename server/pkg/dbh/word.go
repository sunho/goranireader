package dbh

import (
	"github.com/jinzhu/gorm"
)

type Word struct {
	Id            int          `gorm:"column:word_id;primary_key" json:"id"`
	Word          string       `gorm:"column:word;not null;unique" json:"word"`
	Pronunciation *string      `gorm:"column:word_pronunciation" json:"pronunciation,omitempty"`
	Definitions   []Definition `json:"definitions,omitempty"`
}

func (Word) TableName() string {
	return "word"
}

type Definition struct {
	Id         int       `gorm:"column:definition_id;primary_key" json:"id"`
	WordId     int       `gorm:"column:word_id;not null" json:"word_id"`
	Definition string    `gorm:"column:definition;not null" json:"definition"`
	POS        *string   `gorm:"column:definition_pos" json:"pos,omitempty"`
	Examples   []Example `json:"examples,omitempty"`
}

func (Definition) TableName() string {
	return "definition"
}

type Example struct {
	DefinitionId int     `gorm:"column:definition_id;not null" json:"definition_id"`
	Foreign      string  `gorm:"column:foreign;not null" json:"foreign"`
	Native       *string `gorm:"column:native" json:"native,omitempty"`
}

func (Example) TableName() string {
	return "example"
}

func AddWord(db *gorm.DB, word *Word) error {
	err := db.Create(word).Error
	return err
}

func GetWordById(db *gorm.DB, id int) (word Word, err error) {
	err = db.
		Preload("Definitions").
		Preload("Definitions.Examples").
		First(&word, id).Error
	return
}

func GetWordByWord(db *gorm.DB, str string) (word Word, err error) {
	err = db.
		Preload("Definitions").
		Preload("Definitions.Examples").
		Where("word = ?", str).
		First(&word).Error
	return
}

func GetWords(db *gorm.DB) (words []Word, err error) {
	err = db.Find(&words).Error
	return
}

func (w *Word) Delete(db *gorm.DB) error {
	err := db.Delete(w).Error
	return err
}
