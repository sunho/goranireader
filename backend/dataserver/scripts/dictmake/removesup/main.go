package main

import (
	"log"
	"regexp"

	"github.com/jinzhu/gorm"

	_ "github.com/jinzhu/gorm/dialects/sqlite"
)

type Word struct {
	Word string       `gorm:"column:word;not null;primary_key" json:"word"`
	Pron *string      `gorm:"column:pron" json:"pron,omitempty"`
	Defs []Definition `gorm:"association_save_reference:false" json:"defs,omitempty"`
}

func (Word) TableName() string {
	return "words"
}

type Definition struct {
	ID   int     `gorm:"column:id;primary_key" json:"id"`
	Word string  `gorm:"column:word;not null" json:"word"`
	Def  string  `gorm:"column:def;not null" json:"def"`
	POS  *string `gorm:"column:pos" json:"pos,omitempty"`
}

func (Definition) TableName() string {
	return "defs"
}

func main() {
	db, err := gorm.Open("sqlite3", "dict.db")
	db.LogMode(false)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	var words []Word
	err = db.Find(&words).Error
	if err != nil {
		log.Fatal(err)
	}

	re := regexp.MustCompile(`(.+?)([0-9]+)$`)

	visit := make(map[string]bool)

	for _, word := range words {
		w := re.ReplaceAllString(word.Word, "$1")
		if w == word.Word {
			continue
		}
		var count int
		err = db.Table("words").Where("word = ?", w).Count(&count).Error
		if err != nil {
			log.Fatal(err)
		}
		if count == 1 {
			continue
		}
		if _, ok := visit[w]; ok {
			err = db.Delete(&word).Error
		} else {
			err = db.Exec("UPDATE words SET word = ? WHERE word = ?", w, word.Word).Error
			visit[w] = true
		}
		if err != nil {
			log.Fatal(err)
		}
	}

	var defs []Definition
	err = db.Find(&defs).Error
	if err != nil {
		log.Fatal(err)
	}

	for _, def := range defs {
		w := re.ReplaceAllString(def.Word, "$1")
		if w == def.Word {
			continue
		}
		err = db.Exec("UPDATE defs SET word = ? WHERE word = ?", w, def.Word).Error
		if err != nil {
			log.Fatal(err)
		}
	}
}
