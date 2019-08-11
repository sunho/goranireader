package booky

type Book struct {
	Meta     Metadata  `msgpack:"meta"`
	Chapters []Chapter `msgpack:"chapters"`
}

type Metadata struct {
	ID     string `msgpack:"id"`
	Title  string `msgpack:"title"`
	Author string `msgpack:"author"`
	Cover  []byte `msgpack:"cover"`
}

type Chapter struct {
	Title    string     `msgpack:"title"`
	FileName string     `msgpack:"file_name"`
	Items    []Sentence `msgpack:"items"`
}

type Sentence struct {
	ID      string `msgpack:"id"`
	Start   bool   `msgpack:"start"`
	Content string `msgpack:"content"`
}
