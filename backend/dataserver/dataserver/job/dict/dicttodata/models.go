//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package main

type Word struct {
	Word string       `gorm:"column:word;not null;primary_key" json:"word"`
	Pron *string      `gorm:"column:pron" json:"pron,omitempty"`
	Defs []Definition `gorm:"association_save_reference:false" json:"defs,omitempty" db:"-"`
}

func (Word) TableName() string {
	return "words"
}

type Definition struct {
	ID   int     `gorm:"column:id;primary_key" json:"id"`
	Word string  `gorm:"column:word;not null" json:"word"`
	Def  string  `gorm:"column:def;not null" json:"def"`
	POS  *string `gorm:"column:pos" json:"pos,omitempty" db:"pos"`
}

func (Definition) TableName() string {
	return "defs"
}
