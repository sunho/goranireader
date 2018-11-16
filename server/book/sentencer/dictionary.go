package sentencer

type (
	WordId int

	Sentence struct {
		Origin string
		Words  []WordId
	}

	Dictionary map[string]WordId
)

func NewDictionary(words []int) Dictionary {
	d := Dictionary{}
	return d
}
