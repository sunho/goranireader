//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"runtime"
	"sync"
	"time"

	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/sqlite"
)

var mu sync.Mutex
var total = 0
var n = 0

var clear map[string]func() //create a map for storing clear funcs

func init() {
	clear = make(map[string]func()) //Initialize it
	clear["linux"] = func() {
		cmd := exec.Command("clear") //Linux example, its tested
		cmd.Stdout = os.Stdout
		cmd.Run()
	}
	clear["windows"] = func() {
		cmd := exec.Command("cmd", "/c", "cls") //Windows example, its tested
		cmd.Stdout = os.Stdout
		cmd.Run()
	}
	clear["darwin"] = func() {
		cmd := exec.Command("clear") //Linux example, its tested
		cmd.Stdout = os.Stdout
		cmd.Run()
	}
}

func callClear() {
	value, ok := clear[runtime.GOOS] //runtime.GOOS -> linux, windows, darwin etc.
	if ok {                          //if we defined a clear func for that platform:
		value() //we execute it
	} else { //unsupported platform
		panic("Your platform is unsupported! I can't clear terminal screen :(")
	}
}

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

func progress() {
	t := time.NewTicker(time.Second)
	for _ = range t.C {
		callClear()
		mu.Lock()
		fmt.Println("success:", n, "total:", total)
		mu.Unlock()
	}
}

func main() {
	db, err := gorm.Open("sqlite3", "dict.db")
	db.LogMode(false)
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

	var words2 map[string]map[string]Word
	err = json.Unmarshal(buf, &words2)
	if err != nil {
		log.Fatal(err)
	}
	words := []Word{}

	for _, words3 := range words2 {
		for _, word := range words3 {
			words = append(words, word)
		}
	}

	total = len(words)

	go progress()

	err = insert(db, words)
	if err != nil {
		log.Fatal(err)
	}

	log.Println(n)
}

func migrate(db *gorm.DB) error {
	err := db.AutoMigrate(&Word{}, &Definition{}).Error
	if err != nil {
		return err
	}

	db.Model(&Definition{}).AddIndex("idx_definition", "word")
	return err
}

func insert(db *gorm.DB, words []Word) error {
	db = db.Set("gorm:save_associations", false)

	for _, word := range words {
		fmt.Println(word.Word)
		tmp := []Word{}
		if err := db.Where("word = ?", word.Word).Find(&tmp); err != nil {
			if len(tmp) != 0 {
				continue
			}
		}

		mu.Lock()
		n++
		mu.Unlock()

		if err := db.
			Create(&word).Error; err != nil {
			return err
		}

		defs := word.Defs

		for _, def := range defs {
			def.Word = word.Word
			if err := db.
				Create(&def).Error; err != nil {
				return err
			}
		}
	}

	return nil
}
