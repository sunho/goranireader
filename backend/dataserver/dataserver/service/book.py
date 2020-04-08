class BookService:
    def __init__(self, books):
        self.books = dict()
        for book in books:
            self.books[book.meta.id] = book

    def get_book(self, book_id):
        return self.books.get(book_id, None)

    def get_sentence(self, sentence_id):
        for book in self.books.values():
            out = book.get_sentence(sentence_id)
            if out is not None:
                return out
        return None

    def get_item(self, id):
        for book in self.books.values():
            out = book.get_item(id)
            if out is not None:
                return out
        return None

    def get_book_ids(self):
        return self.books.keys()