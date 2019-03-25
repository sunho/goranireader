package sentencer

type (
	WordID string

	Sentence struct {
		Origin string
		Words  []WordID
	}

	Dictionary map[string]WordID
)
