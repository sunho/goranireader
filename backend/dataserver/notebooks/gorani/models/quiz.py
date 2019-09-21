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
    itemstag = root.find('items')
    meta = Metadata.fromXML(metatag)
    chapstag = root.find('chapters')
    chapters = list()
    for chap in chapstag:
      chapters.append(Chapter.fromXML(chap))
    out = Book(meta)
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
      items.append(Sentence.fromXML(item))
    title = tag.get('title')
    id = tag.get('id')
    file_name = tag.get('fileName')
    return Chapter(id, title, file_name, items)

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
