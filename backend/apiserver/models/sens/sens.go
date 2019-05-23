//
// Copyright © 2019 Sunho Kim. All rights reserved.
//

package sens

import (
	"encoding/base64"
	"encoding/json"
	"gorani/book/bookparse"
	"io/ioutil"
)

const MIME = "application/x-gorani-sens"

type Sens struct {
	BookID    int        `json:"book_id"`
	Name      string     `json:"name"`
	Cover     string     `json:"cover"`
	Author    string     `json:"author"`
	Sentences []Sentence `json:"sentences"`
}

type Sentence struct {
	ID            int      `json:"id"`
	Text          string   `json:"text"`
	Answers       []string `json:"answers"`
	CorrectAnswer int      `json:"correct_answer"`
}

func NewFromBook(b bookparse.Book) (Sens, error) {
	var out Sens

	out.Sentences = make([]Sentence, 0, len(b.Sentences))
	for i, sen := range b.Sentences {
		out.Sentences = append(out.Sentences, Sentence{
			ID:      i,
			Text:    sen.Origin,
			Answers: []string{},
		})
	}

	out.Name = b.Name
	out.Author = b.Author
	if b.Cover.Reader == nil {
		return out, nil
	}

	buf, err := ioutil.ReadAll(b.Cover.Reader)
	if err != nil {
		return Sens{}, err
	}

	out.Cover = base64.StdEncoding.EncodeToString(buf)
	return out, nil
}

func (s *Sens) Encode() []byte {
	buf, _ := json.Marshal(s)
	return buf
}
