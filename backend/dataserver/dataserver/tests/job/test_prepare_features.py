import pytest
import pandas as pd
from dataserver.job.prepare_features import prepare_simple_features

def test_prepare_numeric_features():
    signals_df = pd.DataFrame([
        {
            "pageId": 0,
            "time": 30,
            "userId": "test",
            "session": 0,
            "pos": "NN",
            "word": "hey",
            "signal": 1.0,
        },
        {
            "pageId": 0,
            "time": 400030,
            "userId": "test",
            "session": 0,
            "pos": "NN",
            "word": "hey",
            "signal": 0.0,
        },
        {
            "pageId": 0,
            "time": 800030,
            "userId": "test",
            "session": 0,
            "pos": "NN",
            "word": "hey",
            "signal": 1.0,
        },
    ])

    df = prepare_simple_features(signals_df)

    df2 = pd.DataFrame([
        {
            'word': 'hey',
            'signal': 0.0,
            'diff': (400000.0/(60*60*24)),
            'csignal': 1.0,
            'count': 1,
            'time': 400000,
            'userId': 'test'
        },
        {
            'word': 'hey',
            'signal': 1.0,
            'diff': (400000.0 / (60 * 60 * 24)),
            'csignal': 0.5,
            'count': 2,
            'time': 800000,
            'userId': 'test'
        }
    ])

    pd.testing.assert_frame_equal(df.sort_index(axis=1).reset_index(drop=True), df2.sort_index(axis=1))
