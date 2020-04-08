import pytest
from dataserver.job.preprocess_pages import parse_word_unknowns
from dataserver.booky import Book, Metadata, Sentence, Chapter
from dataserver.service import BookService

def test_book_service():
    book = Book(Metadata("test_book", "world", "", "test", ""), [
        Chapter(
            "test",
            "test",
            "test",
            [
                Sentence("test_sentence", False, "hello")
            ]
        )
    ])
    service = BookService([book])
    assert service.get_sentence('anything') is None
    assert service.get_sentence('test_sentence') == 'hello'
    sen = service.get_item('test_sentence')
    assert sen is not None
    assert sen.content == 'hello'
    assert sen.start == False
    assert service.get_book('anything') is None
    assert service.get_book('test_book').meta.title == 'world'

