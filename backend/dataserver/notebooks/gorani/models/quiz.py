import json
import typing
import xml.etree.ElementTree as xml
import xml.sax.saxutils as saxutils

class Quiz:
  def __init__(self):
    self.chapters= list()
  def toXML(self):
    out = xml.Element('quiz')
    chapstag = xml.Element('chapters')
    for chap in self.chapters:
      chapstag.append(chap.toXML())
    out.append(chapstag)
    return xml.tostring(out, encoding='utf8', method='xml')
  @staticmethod
  def fromXML(buf):
    root = xml.fromstring(buf)
    chapstag = root.find('chapters')
    chapters = list()
    for chap in chapstag:
      chapters.append(Chapter.fromXML(chap))
    out = Quiz()
    out.chapters = chapters
    return out

class Chapter(typing.NamedTuple):
  id: str
  items: typing.List[object]
  def toXML(self):
    out = xml.Element('chapter', id=self.id)
    for item in self.items:
      out.append(item.toXML())
    return out
  @staticmethod
  def fromXML(tag):
    items = list()
    for item in tag:
      items.append(WordItem.fromXML(item))
    id = tag.get('id')
    return Chapter(id, items)

class WordItem(typing.NamedTuple):
  id: str
  sentence: str
  wordIndex: int
  options: typing.List[str]
  answer: int
  word: str
  def toXML(self):
    out = xml.Element('item', id=self.id, type='word', wordIndex=str(self.wordIndex), sentence=self.sentence, answer=str(self.answer), word=self.word)
    for item in self.options:
        out.append(xml.Element('option', content=item))
    return out
  def toDict(self):
    return {
        'id': self.id,
        'sentence': self.sentence,
        'wordIndex': self.wordIndex,
        'options': self.options,
        'answer': self.answer,
        'type': 'word'
    }

  @staticmethod
  def fromXML(tag):
    id = tag.get('id')
    sentence = tag.get('sentence')
    wordIndex = int(tag.get('wordIndex'))
    answer = int(tag.get('answer'))
    word = tag.get('word')
    items = list()
    for item in tag:
      items.append(item.get('content'))
    return WordItem(id, sentence, wordIndex, items, answer, word)
