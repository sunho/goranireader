from collections import namedtuple

Sentence = namedtuple('Sentence', ['id', 'content'])
Chapter = namedtuple('Chapter', ['title', 'file_name', 'items'])
Metadata = namedtuple('Metadata', ['id', 'title', 'cover', 'author'])

class Book:
  def __init__(self, meta):
    self.meta = meta
    self.chapters = list()