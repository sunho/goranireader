import pandas as pd
import json
from dataserver.job.review import serialize_review_words_df, serialize_stats_df, combine_serialized_dfs\
    , decide_review_words
import uuid
import time

from dataserver.models.vocab_skill import VocabSkill


def test_serialize_review_words_df():
    review_words_df = pd.DataFrame([
        {
            "userId": "test",
            "word": "2",
            "pageId": 1,
            "priority": 1
        },
        {
            "userId": "test",
            "word": "1",
            "pageId": 0,
            "priority": 2
        }
    ])
    clean_pages_df = pd.DataFrame([
        {
            "userId": "test",
            "pageId": 0,
            "itemsJson": '"page 0"'
        },
        {
            "userId": "test",
            "pageId": 1,
            "itemsJson": '"page 1"'
        }
    ])
    target_df = pd.DataFrame([
        {
            "userId": "test",
            "targetReviewWords": 10
        }
    ])
    words = [
        {
            "word": "1",
            "items": "page 0"
        },
        {
            "word": "2",
            "items": "page 1"
        }
    ]
    df = serialize_review_words_df(review_words_df, clean_pages_df, target_df)
    df2 = pd.DataFrame([
        {
            "userId": "test",
            "reviewWords": json.dumps(words),
            "targetReviewWords": 10
        }
    ])
    pd.testing.assert_frame_equal(df.sort_index(axis=1).reset_index(drop=True), df2.sort_index(axis=1))

def test_serialize_stats_df():
    df = pd.DataFrame([
        {
            "userId": "test",
            "readWords": 2,
            "unknownWords": 1,
            "hours": 0.4,
            "session": 0,
            "wpm": 30.0,
            "start": 1586428433,
            "end": 1586428435
        },
    ])

    df = serialize_stats_df(df)
    stats = {
        "lastReadWords": [{"time": "04-09", "y": 2}],
        "wpm": [{"time": "04-09", "y": 30.0}],
        "hours": [{"time": "04-09", "y": 0.4}]
    }
    df2 = pd.DataFrame([
        {
            "userId": "test",
            "stats": json.dumps(stats)
        }
    ])
    pd.testing.assert_frame_equal(df.sort_index(axis=1).reset_index(drop=True), df2.sort_index(axis=1))


def test_combine_serialized_dfs(monkeypatch):
    last_session_df = pd.DataFrame([
        {
            "userId": "test",
            "session": 0
        },
    ])

    session_info_df = pd.DataFrame([
        {
            "userId": "test",
            "readWords": 2,
            "unknownWords": 1,
            "hours": 0.4,
            "session": 0,
            "wpm": 30.0,
            "start": 1586428433,
            "end": 1586428435
        },
    ])

    words = [
        {
            "word": "1",
            "items": "page 0"
        },
        {
            "word": "2",
            "items": "page 1"
        }
    ]
    review_words_df = pd.DataFrame([
        {
            "userId": "test",
            "reviewWords": json.dumps(words),
            "targetReviewWords": 10
        }
    ])

    stats = {
        "lastReadWords": [{"time": "04-09", "y": 2}],
        "wpm": [{"time": "04-09", "y": 30.0}],
        "hours": [{"time": "04-09", "y": 0.4}]
    }
    stats_df = pd.DataFrame([
        {
            "userId": "test",
            "stats": json.dumps(stats)
        }
    ])

    def now(*args, **kwargs):
        return 1234

    monkeypatch.setattr(time, "time", now)

    def uuid4(*args, **kwargs):
        return "test"

    monkeypatch.setattr(uuid, "uuid4", uuid4)


    df = combine_serialized_dfs(stats_df, review_words_df, last_session_df, session_info_df)

    review = {
        'id': "test",
        'stats': stats,
        'time': 1234,
        'reviewWords': words,
        'targetReviewWords': 10,
        'start': 1586428433,
        'end': 1586428435
    }

    df2 = pd.DataFrame([
        {
            "userId": "test",
            "review": json.dumps(review),
        }
    ])
    pd.testing.assert_frame_equal(df.sort_index(axis=1).reset_index(drop=True), df2.sort_index(axis=1))

def test_decide_review_words():
    unknown_words_df = pd.DataFrame([
        {
            "userId": "test",
            "word": "world",
            "oword": "world",
            "time": 13 * 60 * 60,
            "pageId": 0,
        },
        {
            "userId": "test",
            "word": "hello",
            "oword": "hello",
            "time": 13 * 60 * 60,
            "pageId": 1,
        }
    ])

    vocab_skills = [
        VocabSkill('test', 1, ['hello'])
    ]

    last_session_df = pd.DataFrame([
        {
            "userId": "test",
            "end": 24 * 60 * 60,
            "session": 0
        }
    ])

    df = decide_review_words(unknown_words_df, vocab_skills, last_session_df, 12)

    df2 = pd.DataFrame([
        {
            'userId': 'test',
            'pageId': 1,
            'word': 'hello',
            'priority': 1.0833333333,
        },
        {
            'userId': 'test',
            'pageId': 0,
            'word': 'world',
            'priority': 0.0833333333,
        }
    ])
    pd.testing.assert_frame_equal(df, df2, check_dtype=False)
