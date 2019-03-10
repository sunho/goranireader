package quiz

type Quiz struct {
	BookID    int `json:"book_id"`
	Questions []Question
}

type Question struct {
	ID          int      `json:"id"`
	Chapter     int      `json:"chapter"`
	Text        string   `json:"text"`
	Answers     []string `json:"answers"`
	Explanation string   `json:"explanation"`
}
