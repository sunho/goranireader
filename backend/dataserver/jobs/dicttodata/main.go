//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package main

import (
	"log"

	"github.com/gocql/gocql"
	"github.com/jinzhu/gorm"
	"github.com/scylladb/gocqlx"
	"github.com/scylladb/gocqlx/qb"

	_ "github.com/jinzhu/gorm/dialects/sqlite"
)

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

	cluster := gocql.NewCluster("cassandra")
	cluster.ProtoVersion = 4
	cluster.DisableInitialHostLookup = true
	cluster.Keyspace = "gorani"
	sess, err := cluster.CreateSession()
	if err != nil {
		log.Fatal(err)
	}

	for _, word := range words {
		var defs []Definition
		err = db.Where("word = ?", word.Word).Find(&defs).Error
		if err != nil {
			log.Fatal(err)
		}

		stmt, names := qb.Insert("words").Columns("word", "pron").ToCql()
		q := gocqlx.Query(sess.Query(stmt), names).BindStruct(word)
		if err := q.ExecRelease(); err != nil {
			log.Fatal(err)
		}

		for _, def := range defs {
			def.Word = word.Word
			stmt, names := qb.Insert("word_defs").Columns("id", "word", "def", "pos").ToCql()
			q := gocqlx.Query(sess.Query(stmt), names).BindStruct(def)
			if err := q.ExecRelease(); err != nil {
				log.Fatal(err)
			}
		}
	}
}
