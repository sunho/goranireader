import pytest
import numpy as np
import pandas as pd
from dataserver.job.ml import predict_vocab
from dataserver.tests.mocks.nlp_service import MockNLPService


def test_predict_vocab():
    nlp_service = MockNLPService()
    signals = pd.DataFrame([
        {
            "pageId": 0,
            "time": 30,
            "userId": "test",
            "session": 0,
            "cheat": True,
            "wpm": 30.0,
            "pos": "NN",
            "word": "hello",
            "signal": 1.0,
        },
        {
            "pageId": 0,
            "time": 60,
            "userId": "test",
            "session": 0,
            "cheat": True,
            "wpm": 30.0,
            "pos": "NN",
            "word": "hello",
            "signal": 1.0,
        },
        {
            "pageId": 0,
            "time": 30,
            "userId": "test",
            "session": 0,
            "cheat": True,
            "wpm": 30.0,
            "pos": "NN",
            "word": "world",
            "signal": 0.0,
        }
    ])

    features = pd.DataFrame([
        {
            'oword': 'world',
            'word': 'world',
            'otime': 40,
            'signal': 1.0,
            'diff': (400000.0 / (60 * 60 * 24)),
            'csignal': (2 / 3),
            'count': 3,
            "wpm": 10.0,
            'pos': "NN",
            'time': 800000,
            'userId': 'test'
        }
    ])

    class MockClassifier:
        def predict(self, x):
            return np.array([1])

    class MockModel:
        def get_classifier(self):
            return MockClassifier()

    ndf, udf = predict_vocab(features, signals, MockModel(), nlp_service)

    ndf2 = pd.DataFrame([
        {
            'userId': 'test',
            'word': 'hello',
            'oword': 'hello',
            'time': 60
        }
    ])
    udf2 = pd.DataFrame([
        {
            'userId': 'test',
            'word': 'world',
            'oword': 'world',
            'time': 40
        }
    ])
    pd.testing.assert_frame_equal(ndf.sort_index(axis=1), ndf2.sort_index(axis=1))
    pd.testing.assert_frame_equal(udf.sort_index(axis=1), udf2.sort_index(axis=1))
