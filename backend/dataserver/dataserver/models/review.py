from typing import NamedTuple, List
import json

class ReviewWord(NamedTuple):
    word: str
    time: int
    items: dict

class Review(NamedTuple):
    id: str
    stats: dict
    time: int
    reviewWords: List[ReviewWord]
    targetReviewWords: int
    start: int
    end: int

    @classmethod
    def from_json(cls, buf):
        obj = json.loads(buf)
        if 'reviewWords' in obj:
            reviewWords = [ReviewWord(**word) for word in obj['reviewWords']]
        else:
            reviewWords = [ReviewWord(**word) for word in obj['lastWords']]
            obj['targetLastWords'] = obj['targetReviewWords']
        obj['reviewWords'] = reviewWords
        return cls(**obj)

