import pytest
import json
from dataserver.models.review import Review, ReviewWord
from deepdiff import DeepDiff

def test_review_model():
    model = {
        'id': 'test',
        'stats': dict(),
        'time': 12,
        'reviewWords': [
            {
                'word': 'test',
                'time': 10,
                'items': dict()
            }
        ],
        'targetReviewWords': 10,
        'start': 12,
        'end': 123
    }
    review = Review.from_json(json.dumps(model))
    solution = Review(
        id='test',
        stats=dict(),
        time=12,
        reviewWords=[
            ReviewWord(
                word='test',
                time=10,
                items=dict()
            )
        ],
        targetReviewWords=10,
        start=12,
        end=123
    )
    assert not DeepDiff(solution,review)
