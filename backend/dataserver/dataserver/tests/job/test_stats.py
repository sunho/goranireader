import pytest

from dataserver.job.stats import extract_last_session_df, extract_session_info_df, calculate_vocab_skills
import pandas as pd

import time

from dataserver.models.vocab_skill import VocabSkill
from dataserver.service.user import UserService


def test_extract_session_info_df():
    df = pd.DataFrame([
        {
            "pageId": 0,
            "time": 30,
            "userId": "test",
            "session": 0,
            "cheat": True,
            "pos": "NN",
            "word": "1",
            "signal": 1.0,
        },
        {
            "pageId": 0,
            "time": 30,
            "userId": "test",
            "session": 0,
            "cheat": True,
            "pos": "NN",
            "word": "2",
            "signal": 0.0,
        },
        {
            "pageId": 0,
            "time": 40,
            "userId": "test",
            "session": 1,
            "cheat": True,
            "pos": "NN",
            "word": "3",
            "signal": 0.0,
        },
        {
            "pageId": 0,
            "time": 50,
            "userId": "test",
            "session": 1,
            "cheat": True,
            "pos": "NN",
            "word": "4",
            "signal": 0.0,
        },
    ])

    df2 = pd.DataFrame([
        {
            "time": 30,
            "userId": "test",
            "eltime": 30 * 60.0,
            "wpm": 30.0,
            "session": 0,
            "words": ["1", "2"],
            "knownWords": ["1"],
            "unknownWords": ["2"],
            "itemsJson": ""
        },
        {
            "time": 40,
            "userId": "test",
            "eltime": 30 * 60.0,
            "wpm": 30.0,
            "session": 1,
            "words": ["3"],
            "knownWords": [],
            "unknownWords": ["3"],
            "itemsJson": ""
        },
        {
            "time": 50,
            "userId": "test",
            "eltime": 30*60.0,
            "wpm": 30.0,
            "session": 1,
            "words": ["4"],
            "knownWords": [],
            "unknownWords": ["4"],
            "itemsJson": ""
        }
    ])

    df3 = pd.DataFrame([
        {
            "userId": "test",
            "readWords": 2,
            "unknownWords": 1,
            "hours":  0.5,
            "session": 0,
            "wpm": 30.0,
            "start": 30,
            "end": 30
        },
        {
            "userId": "test",
            "readWords": 2,
            "unknownWords": 2,
            "hours":  1.0,
            "session": 1,
            "wpm": 30.0,
            "start": 40,
            "end": 50
        }
    ])

    df = extract_session_info_df(df, df2)
    pd.testing.assert_frame_equal(df.sort_index(axis=1).reset_index(drop=True), df3.sort_index(axis=1))

def test_extract_last_session_df_simple(monkeypatch):
    service = UserService({
        "test": {
            "lastReviewEnd": 10
        }
    })
    raw_df = pd.DataFrame([
        {
            "userId": "test",
            "readWords": 2,
            "unknownWords": 1,
            "hours":  0.5,
            "session": 0,
            "wpm": 30.0,
            "start": 30,
            "end": 30
        },
        {
            "userId": "test",
            "readWords": 2,
            "unknownWords": 2,
            "hours":  1.0,
            "session": 1,
            "wpm": 30.0,
            "start": 40,
            "end": 50
        },
        {
            "userId": "test",
            "readWords": 2,
            "unknownWords": 2,
            "hours": 1.0,
            "session": 2,
            "wpm": 30.0,
            "start": 50,
            "end": 60
        }
    ])

    def now(*args, **kwargs):
        return 3630

    monkeypatch.setattr(time, "time", now)

    df = extract_last_session_df(raw_df, service, 1, 0.1)
    df2 = pd.DataFrame([
        {
            "userId": "test",
            "session": 0
        }
    ])
    pd.testing.assert_frame_equal(df.sort_index(axis=1).reset_index(drop=True), df2.sort_index(axis=1))

    # skip last hours
    def now(*args, **kwargs):
        return 3640

    monkeypatch.setattr(time, "time", now)

    df = extract_last_session_df(raw_df, service, 1, 0.1)
    df2 = pd.DataFrame([
        {
            "userId": "test",
            "session": 1
        }
    ])
    pd.testing.assert_frame_equal(df.sort_index(axis=1).reset_index(drop=True), df2.sort_index(axis=1))

    # skip lastReviewEnd

    service = UserService({
        "test": {
            "lastReviewEnd": 50
        }
    })

    df = extract_last_session_df(raw_df, service, 1, 0.1)
    df2 = pd.DataFrame([
        {
            "userId": "test",
            "session": -1
        }
    ])
    pd.testing.assert_frame_equal(df.sort_index(axis=1).reset_index(drop=True), df2.sort_index(axis=1))

def test_extract_last_session_df_skip(monkeypatch):
    service = UserService({
        "test": {
            "lastReviewEnd": 10
        }
    })
    df = pd.DataFrame([
        {
            "userId": "test",
            "readWords": 2,
            "unknownWords": 1,
            "hours": 0.4,
            "session": 0,
            "wpm": 30.0,
            "start": 30,
            "end": 40
        },
        {
            "userId": "test",
            "readWords": 2,
            "unknownWords": 1,
            "hours": 0.05,
            "session": 1,
            "wpm": 30.0,
            "start": 40,
            "end": 50
        }
    ])

    def now(*args, **kwargs):
        return 3640

    monkeypatch.setattr(time, "time", now)

    df = extract_last_session_df(df, service, 1, 0.1)
    df2 = pd.DataFrame([
        {
            "userId": "test",
            "session": 0
        }
    ])
    pd.testing.assert_frame_equal(df.sort_index(axis=1).reset_index(drop=True), df2.sort_index(axis=1))

def test_extract_last_session_df_no_user(monkeypatch):
    service = UserService({
        "test2": {
            "lastReviewEnd": 10
        }
    })
    df = pd.DataFrame([
        {
            "userId": "test",
            "readWords": 2,
            "unknownWords": 1,
            "hours": 0.4,
            "session": 0,
            "wpm": 30.0,
            "start": 30,
            "end": 40
        },
        {
            "userId": "test",
            "readWords": 2,
            "unknownWords": 1,
            "hours": 0.05,
            "session": 1,
            "wpm": 30.0,
            "start": 40,
            "end": 50
        }
    ])

    def now(*args, **kwargs):
        return 3640

    monkeypatch.setattr(time, "time", now)

    df = extract_last_session_df(df, service, 1, 0.1)
    df2 = pd.DataFrame([
        {
            "userId": "test",
            "session": -1
        }
    ])
    pd.testing.assert_frame_equal(df.sort_index(axis=1).reset_index(drop=True), df2.sort_index(axis=1))

def test_extract_last_session_df_no_available(monkeypatch):
    service = UserService({
        "test": {
            "lastReviewEnd": 10
        }
    })
    df = pd.DataFrame([
        {
            "userId": "test",
            "readWords": 2,
            "unknownWords": 1,
            "hours": 0.4,
            "session": 0,
            "wpm": 30.0,
            "start": 30,
            "end": 40
        },
    ])

    def now(*args, **kwargs):
        return 0

    monkeypatch.setattr(time, "time", now)

    df = extract_last_session_df(df, service, 1, 0.1)
    df2 = pd.DataFrame([
        {
            "userId": "test",
            "session": -1
        }
    ])
    pd.testing.assert_frame_equal(df.sort_index(axis=1).reset_index(drop=True), df2.sort_index(axis=1))

def test_calculate_vocab_skills():
    df = pd.DataFrame([
        {
            "userId": "test",
            "word": 'hey'
        },
        {
            "userId": "test",
            "word": 'hey2'
        },
        {
            "userId": "test2",
            "word": 'hey2'
        },
        {
            "userId": "test2",
            "word": 'hey'
        },
        {
            "userId": "test2",
            "word": 'hey3'
        }
    ])

    vc = VocabSkill('test', 1, ['hey', 'hey3'])
    df2 = calculate_vocab_skills(df, [vc])
    df3 = pd.DataFrame([
        {
            "userId": "test",
            "name": 'test',
            'perc': 0.5
        },
        {
            "userId": "test2",
            "name": 'test',
            'perc': 1.0
        }
    ])
    pd.testing.assert_frame_equal(df2.sort_index(axis=1), df3.sort_index(axis=1))