package main

import (
	"encoding/json"
	"io/ioutil"
	"log"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/sqlite"
)

type Word struct {
	Id            int          `gorm:"column:word_id;primary_key" json:"id"`
	Word          string       `gorm:"column:word;not null;unique" json:"word"`
	Pronunciation *string      `gorm:"column:word_pronunciation" json:"pron,omitempty"`
	Definitions   []Definition `json:"defs,omitempty"`
}

func (Word) TableName() string {
	return "word"
}

type Definition struct {
	Id         int       `gorm:"column:definition_id;primary_key" json:"id"`
	WordId     int       `gorm:"column:word_id;not null" json:"word_id"`
	Definition string    `gorm:"column:definition;not null" json:"def"`
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

func main() {
	db, err := gorm.Open("sqlite3", "dict.db")
	db.LogMode(true)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	err = migrate(db)
	if err != nil {
		log.Fatal(err)
	}

	buf, err := ioutil.ReadFile("dict.json")
	if err != nil {
		log.Fatal(err)
	}

	var dict map[string]Word
	err = json.Unmarshal(buf, &dict)
	if err != nil {
		log.Fatal(err)
	}

	words := []Word{}
	for _, word := range dict {
		words = append(words, word)
	}

	err = insert(db, words)
	if err != nil {
		log.Fatal(err)
	}
}

func migrate(db *gorm.DB) error {
	err := db.AutoMigrate(&Word{}, &Definition{}, &Example{}).Error
	if err != nil {
		return err
	}

	db.Model(&Definition{}).AddIndex("idx_definition", "word_id")
	db.Model(&Example{}).AddIndex("idx_example", "definition_id")
	return err
}

func insert(db *gorm.DB, words []Word) error {
	db = db.Set("gorm:save_associations", false)

	for _, word := range words {
		if err := db.
			Create(&word).Error; err != nil {
			return err
		}

		defs := word.Definitions

		for _, def := range defs {
			def.WordId = word.Id
			if err := db.
				Create(&def).Error; err != nil {
				return err
			}
			examples := def.Examples

			for _, example := range examples {
				example.DefinitionId = def.Id
				if err := db.
					Create(&example).Error; err != nil {
					return err
				}
			}
		}
	}

	return nil
}
