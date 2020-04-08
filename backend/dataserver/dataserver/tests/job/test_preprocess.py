import pytest
from dataserver.job.preprocess_pages import parse_word_unknowns, parse_paginate_logs, merge_pages_df, annotate_pages_df, extract_signals_df, clean_pages_df
from dataserver.booky import Book, Metadata, Sentence, Chapter
from dataserver.service import BookService
from dataserver.tests.mocks.nlp_service import MockNLPService
import pandas as pd

def test_parse_word_unknowns_simple():
    nlp_service = MockNLPService()
    content = "hello world don't\"believe\""
    word_unknowns = [
        {
            'sentenceId': 'test',
            'word': 'hello',
            'wordIndex': 0,
            'time': 10
        },
        {
            'sentenceId': 'test',
            'word': 'believe',
            'wordIndex': 3,
            'time': 10
        }
    ]
    book = Book(Metadata("test", "test", "", "test", ""), [
        Chapter(
            "test",
            "test",
            "test",
            [
                Sentence("test", False, content)
            ]
        )
    ])

    result = parse_word_unknowns(nlp_service, book, ["test"], word_unknowns)
    assert result['unknownIndices'] == [0, 3]
    assert result['unknownWords'] == ['hello', 'believe']
    assert result['words'] == ['hello', 'world', "don't", 'believe']

def test_parse_word_unknowns_invalid():
    nlp_service = MockNLPService()
    content = "hello world don't\"believe\""
    word_unknowns = [
        {
            'sentenceId': 'test',
            'word': 'hello',
            'wordIndex': 0,
            'time': 10
        },
        {
            'sentenceId': 'test',
            'word': 'believe',
            'wordIndex': 2,
            'time': 10
        }
    ]
    book = Book(Metadata("test", "test", "", "test", ""), [
        Chapter(
            "test",
            "test",
            "test",
            [
                Sentence("test", False, content)
            ]
        )
    ])
    with pytest.raises(Exception):
        parse_word_unknowns(nlp_service, book, ["test"], word_unknowns)

def test_parse_paginate_logs():
    nlp_service = MockNLPService()
    content = "hello world don't\"believe\""
    book = Book(Metadata("test", "test", "", "test", ""), [
        Chapter(
            "test",
            "test",
            "test",
            [
                Sentence("test", False, content),
                Sentence("test2", False, content),
            ]
        )
    ])
    service = BookService([book])
    df = pd.DataFrame([
        {
            "userId": "test",
            "fireId": "8VeJWtPHdmZ4apbb3bY3ThBBFZs1",
            "classId": "test2",
            "serverTime": "2020-03-20T15:34:52Z",
            "time": "2020-03-20T15:34:52Z",
            "type": "paginate",
            "payload": "{\"type\":\"paginate\",\"sids\":[\"test\",\"test2\"],\"time\":64300,\"wordUnknowns\":[{\"word\":\"believe\",\"wordIndex\":3,\"sentenceId\":\"test\",\"time\":18500},{\"word\":\"hello\",\"wordIndex\":0,\"sentenceId\":\"test2\",\"time\":26000}],\"sentenceUnknowns\":[],\"bookId\":\"test\",\"chapterId\":\"test\"}"
        }
    ])
    df = parse_paginate_logs(df, nlp_service, service)
    out = pd.DataFrame([
        {
            "time": 1584718492,
            "userId": "test",
            "eltime": 64.3,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["believe", "hello"],
            "unknownIndices": [3, 4]
        }
    ])
    pd.testing.assert_frame_equal(df, out)
    assert df.iloc[0]['words'][3] == "believe"
    assert df.iloc[0]['words'][4] == "hello"

def test_merge_pages_df_same():
    df = pd.DataFrame([
        {
            "time": 10,
            "userId": "test",
            "eltime": 10,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["believe", "hello"],
            "unknownIndices": [3, 4]
        },
    ])

    df = merge_pages_df(df, 1)
    out = pd.DataFrame([
        {
            "time": 10,
            "userId": "test",
            "eltime": 10,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["believe", "hello"],
            "unknownIndices": [3, 4]
        },
    ])
    pd.testing.assert_frame_equal(df.sort_index(axis=1), out.sort_index(axis=1))

def test_merge_pages_df():
    df = pd.DataFrame([
        {
            "time": 30,
            "userId": "test",
            "eltime": 20,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["believe", "hello"],
            "unknownIndices": [3, 4]
        },
        {
            "time": 10,
            "userId": "test",
            "eltime": 10,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["believe", "hello"],
            "unknownIndices": [3, 4]
        },
        {
            "time": 70,
            "userId": "test",
            "eltime": 20,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["hello", "believe", "hello"],
            "unknownIndices": [0, 3, 4]
        }
    ])

    df = merge_pages_df(df, 1)
    out = pd.DataFrame([
        {
            "time": 10,
            "userId": "test",
            "eltime": 50,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["believe", "hello", "believe", "hello", "hello", "believe", "hello"],
            "unknownIndices": [3, 4, 3, 4, 0, 3, 4]
        }
    ])
    pd.testing.assert_frame_equal(df.sort_index(axis=1), out.sort_index(axis=1))


def test_merge_pages_df_multiple():
    df = pd.DataFrame([
        {
            "time": 30,
            "userId": "test",
            "eltime": 20,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["believe", "hello"],
            "unknownIndices": [3, 4]
        },
        {
            "time": 10,
            "userId": "test",
            "eltime": 10,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["believe", "hello"],
            "unknownIndices": [3, 4]
        },
        {
            "time": 80,
            "userId": "test",
            "eltime": 20,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["hello", "believe", "hello"],
            "unknownIndices": [0, 3, 4]
        }
    ])

    df = merge_pages_df(df, 1)
    out = pd.DataFrame([
        {
            "time": 10,
            "userId": "test",
            "eltime": 30,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["believe", "hello", "believe", "hello"],
            "unknownIndices": [3, 4, 3, 4,]
        },
        {
            "time": 80,
            "userId": "test",
            "eltime": 20,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["hello", "believe", "hello"],
            "unknownIndices": [0, 3, 4]
        }
    ])
    pd.testing.assert_frame_equal(df.sort_index(axis=1), out.sort_index(axis=1))

def test_annotate_pages_df():
    df = pd.DataFrame([
        {
            "time": 30,
            "userId": "test",
            "eltime": 20,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["believe", "hello"],
            "unknownIndices": [3, 4]
        },
        {
            "time":  3631,
            "userId": "test",
            "eltime": 20,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["believe", "hello"],
            "unknownIndices": [3, 4]
        }
    ])

    df = annotate_pages_df(df, 1, 1)

    df2 = pd.DataFrame([
        {
            "pageId": 0,
            "time": 30,
            "userId": "test",
            "session": 0,
            "eltime": 20,
            "cheat": True,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["believe", "hello"],
            "unknownIndices": [3, 4]
        },
        {
            "pageId": 1,
            "time": 3631,
            "userId": "test",
            "eltime": 20,
            "session": 1,
            "cheat": True,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["believe", "hello"],
            "unknownIndices": [3, 4]
        }
    ])
    pd.testing.assert_frame_equal(df.sort_index(axis=1), df2.sort_index(axis=1))

def test_extract_signals_df():
    df = pd.DataFrame([
        {
            "pageId": 0,
            "time": 30,
            "userId": "test",
            "session": 0,
            "eltime": 20.0,
            "cheat": True,
            'wpm': 30.0,
            "bookId": "test",
            "sids": ["test"],
            "pos": ["NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "hello", "believe"],
            "unknownWords": ["hello", "believe"],
            "unknownIndices": [0,3]
        }
    ])

    df = extract_signals_df(df)

    df2 = pd.DataFrame([
        {
            "pageId": 0,
            "time": 30,
            "userId": "test",
            "session": 0,
            "eltime": 20.0,
            'wpm': 30.0,
            "cheat": True,
            "pos": "NN",
            "word": "hello",
            "signal": 0.0,
        },
        {
            "pageId": 0,
            "time": 30,
            "userId": "test",
            "session": 0,
            "eltime": 20.0,
            'wpm': 30.0,
            "cheat": True,
            "pos": "NN",
            "word": "world",
            "signal": 1.0,
        },
        {
            "pageId": 0,
            "time": 30,
            "userId": "test",
            "session": 0,
            "eltime": 20.0,
            'wpm': 30.0,
            "cheat": True,
            "pos": "NN",
            "word": "hello",
            "signal": 0.0,
        },
        {
            "pageId": 0,
            "time": 30,
            "userId": "test",
            "session": 0,
            "eltime": 20.0,
            'wpm': 30.0,
            "cheat": True,
            "pos": "NN",
            "word": "believe",
            "signal": 0.0,
        }
    ])
    pd.testing.assert_frame_equal(df.sort_index(axis=1), df2.sort_index(axis=1))

def test_clean_pages_df():
    df = pd.DataFrame([
        {
            "time": 10,
            "userId": "test",
            "eltime": 10,
            "bookId": "test",
            "sids": ["test", "test2"],
            "pos": ["NN", "NN", "NN", "NN", "NN", "NN", "NN", "NN"],
            "words": ["hello", "world", "don't", "believe", "hello", "world", "don't", "believe"],
            "unknownWords": ["believe", "hello"],
            "unknownIndices": [3, 4]
        }
    ])

    df = clean_signals_df(df)

