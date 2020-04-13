import pytest
import pandas as pd
from dataserver.job.prepare_features import prepare_simple_features, prepare_series_features
from dataserver.job.prepare_features import annotate_simple_features
from dataserver.tests.mocks.nlp_service import MockNLPService


def test_prepare_numeric_features():
    nlp_service = MockNLPService()

    signals_df = pd.DataFrame([
        {
            "pageId": 0,
            "time": 30,
            "userId": "test",
            "session": 0,
            "wpm": 10.0,
            "pos": "NN",
            "word": "hey",
            "signal": 1.0,
        },
        {
            "pageId": 0,
            "time": 400030,
            "userId": "test",
            "session": 0,
            "wpm": 10.0,
            "pos": "NN",
            "word": "hey",
            "signal": 0.0,
        },
        {
            "pageId": 0,
            "time": 800030,
            "userId": "test",
            "session": 0,
            "wpm": 10.0,
            "pos": "NN",
            "word": "hey",
            "signal": 1.0,
        },
    ])

    df = prepare_simple_features(signals_df, nlp_service)

    df2 = pd.DataFrame([
        {
            'oword': 'hey',
            'word': 'hey',
            'otime': 400030,
            'signal': 0.0,
            'diff': (400000.0/(60*60*24)),
            'csignal': 1.0,
            'count': 1,
            "wpm": 10.0,
            'pos': "NN",
            'time': 400000,
            'userId': 'test'
        },
        {
            'oword': 'hey',
            'word': 'hey',
            'signal': 1.0,
            'otime': 800030,
            'diff': (400000.0 / (60 * 60 * 24)),
            'csignal': 0.5,
            'count': 2,
            "wpm": 10.0,
            'pos': "NN",
            'time': 800000,
            'userId': 'test'
        }
    ])

    pd.testing.assert_frame_equal(df.sort_index(axis=1).reset_index(drop=True), df2.sort_index(axis=1))


def test_prepare_numeric_features2():
    nlp_service = MockNLPService()

    signals_df = pd.DataFrame([
        {
            "pageId": 0,
            "time": 1200030,
            "userId": "test",
            "session": 0,
            "wpm": 10.0,
            "pos": "NN",
            "word": "hey2",
            "signal": 0.0,
        },
        {
            "pageId": 0,
            "time": 400030,
            "userId": "test",
            "session": 0,
            "wpm": 10.0,
            "pos": "NN",
            "word": "hey",
            "signal": 0.0,
        },
        {
            "pageId": 0,
            "time": 30,
            "userId": "test",
            "session": 0,
            "wpm": 10.0,
            "pos": "NN",
            "word": "hey",
            "signal": 1.0,
        },
        {
            "pageId": 0,
            "time": 800030,
            "userId": "test",
            "session": 0,
            "wpm": 10.0,
            "pos": "NN",
            "word": "hey",
            "signal": 0.0,
        },
        {
            "pageId": 0,
            "time": 800030,
            "userId": "test",
            "session": 0,
            "wpm": 10.0,
            "pos": "NN",
            "word": "hey2",
            "signal": 1.0,
        },
    ])

    df = prepare_simple_features(signals_df, nlp_service)

    df2 = pd.DataFrame([
        {
            'oword': 'hey',
            'word': 'hey',
            'otime': 400030,
            'signal': 0.0,
            'diff': (400000.0/(60*60*24)),
            'csignal': 1.0,
            'count': 1,
            "wpm": 10.0,
            'pos': "NN",
            'time': 400000,
            'userId': 'test'
        },
        {
            'oword': 'hey',
            'word': 'hey',
            'otime': 800030,
            'signal': 0.0,
            'diff': (400000.0 / (60 * 60 * 24)),
            'csignal': 0.5,
            'count': 2,
            "wpm": 10.0,
            'pos': "NN",
            'time': 800000,
            'userId': 'test'
        },
        {
            'oword': 'hey2',
            'word': 'hey2',
            'signal': 0.0,
            'otime': 1200030,
            'diff': (400000.0 / (60 * 60 * 24)),
            'csignal': 1.0,
            'count': 1,
            "wpm": 10.0,
            'pos': "NN",
            'time': 400000,
            'userId': 'test'
        }
    ])

    pd.testing.assert_frame_equal(df.sort_index(axis=1).reset_index(drop=True), df2.sort_index(axis=1))

def test_prepare_series_features():
    signals_df = pd.DataFrame([
        {
            "pageId": 0,
            "time": 1200030,
            "userId": "test",
            "session": 0,
            "wpm": 10.0,
            "pos": "NN",
            "word": "hey2",
            "signal": 0.0,
        },
        {
            "pageId": 0,
            "time": 400030,
            "userId": "test",
            "session": 0,
            "wpm": 10.0,
            "pos": "NN",
            "word": "hey",
            "signal": 0.0,
        },
        {
            "pageId": 0,
            "time": 30,
            "userId": "test",
            "session": 0,
            "wpm": 10.0,
            "pos": "NN",
            "word": "hey",
            "signal": 1.0,
        },
        {
            "pageId": 0,
            "time": 800030,
            "userId": "test",
            "session": 0,
            "wpm": 10.0,
            "pos": "NN",
            "word": "hey",
            "signal": 0.0,
        },
        {
            "pageId": 0,
            "time": 800030,
            "userId": "test",
            "session": 0,
            "wpm": 10.0,
            "pos": "NN",
            "word": "hey2",
            "signal": 1.0,
        },
    ])

    df = prepare_series_features(signals_df)

    df2 = pd.DataFrame([
        {
            'word': 'hey',
            'signal': 0.0,
            'diff0': (400000.0 / (60 * 60 * 24)),
            'diff1': (400000.0 / (60 * 60 * 24)),
            'signal0': 1.0,
            'signal1': 0.0,
            'count': 1,
            "wpm": 10.0,
            'pos': "NN",
            'time': 800000,
            'userId': 'test'
        },
    ])

    pd.testing.assert_frame_equal(df.sort_index(axis=1).reset_index(drop=True), df2.sort_index(axis=1))

def test_annotate_simple_features():
    df = pd.DataFrame([
        {
            'oword': 'hey',
            'word': 'hey',
            'otime': 400030,
            'signal': 0.0,
            'diff': (400000.0 / (60 * 60 * 24)),
            'csignal': 1.0,
            'count': 1,
            "wpm": 10.0,
            'pos': "NN",
            'time': 400000,
            'userId': 'test'
        },
        {
            'oword': 'hey',
            'word': 'hey',
            'signal': 1.0,
            'otime': 800030,
            'diff': (400000.0 / (60 * 60 * 24)),
            'csignal': 0.5,
            'count': 2,
            "wpm": 10.0,
            'pos': "NN",
            'time': 800000,
            'userId': 'test'
        }
    ])

    class MockVecModel:
        def __init__(self):
            self.vocab = ['hey', 'hey2']

        def __getitem__(self, item):
            return {
                'hey': [0, 1],
                'hey2': [1, 0]
            }[item]

    vec_model = MockVecModel()
    import pyphen
    dic = pyphen.Pyphen(lang='en_US')
    annotate_simple_features(df, vec_model, dic, 2)