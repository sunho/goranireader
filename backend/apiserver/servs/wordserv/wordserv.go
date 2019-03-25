package wordserv

import (
	"gorani/book/sentencer"
	"gorani/models/dbmodels"
	"gorani/servs/dbserv"
)

type WordServConf struct {
	Dictionary        []string          `yaml:"dictionary"`
	IrregularPast     map[string]string `yaml:"irregular_past"`
	IrregularComplete map[string]string `yaml:"irregular_complete"`
	Abbrs             []string          `yaml:"abbrs"`
}

type WordServ struct {
	DB   *dbserv.DBServ `dim:"on"`
	conf WordServConf
}

func Provide(conf WordServConf) *WordServ {
	return &WordServ{
		conf: conf,
	}
}

func (w WordServ) ConfigName() string {
	return "word"
}

func (w *WordServ) Init() error {
	var words []dbmodels.Word

	err := w.DB.Q().All(&words)
	if err != nil {
		return err
	}

	old := make([]string, 0, len(words))
	for _, word := range words {
		old = append(old, word.Word)
	}
	new := w.conf.Dictionary

	// add new words
L:
	for _, word := range new {
		for _, word2 := range old {
			if word == word2 {
				continue L
			}
		}
		item := dbmodels.Word{
			Word: word,
		}
		err := w.DB.Create(&item)
		if err != nil {
			return err
		}
	}

	// delete absent words
L2:
	for _, word := range old {
		for _, word2 := range new {
			if word == word2 {
				continue L2
			}
		}
		err := w.DB.Destroy(&dbmodels.Word{Word: word})
		if err != nil {
			return err
		}
	}

	dict := make(sentencer.Dictionary)
	for _, word := range new {
		dict[word] = sentencer.WordID(word)
	}

	sentencer.SetSentencer(sentencer.New(
		dict,
		sentencer.AbbrsToDotSpecialCases(w.conf.Abbrs),
		sentencer.NewStemmer(w.conf.IrregularPast, w.conf.IrregularComplete),
	))

	return nil
}
