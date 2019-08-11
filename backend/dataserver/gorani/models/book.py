import json
import typing
import xml.etree.ElementTree as xml
import xml.sax.saxutils as saxutils

class Sentence(typing.NamedTuple):
  id: str
  start: bool
  content: str
  def toXML(self):
    out = xml.Element('sentence', start=str(self.start).lower(), id=self.id)
    out.text = saxutils.escape(self.content)
    return out
  @staticmethod
  def fromXML(tag):
    start = False
    start_raw = tag.get('start')
    if start_raw == 'true':
      start = True
    id = tag.get('id')
    return Sentence(id, start, tag.text)

class Chapter(typing.NamedTuple):
  title: str
  file_name: str
  items: typing.List[Sentence]
  def toXML(self):
    title = self.title
    if title is None:
      title = ''
    out = xml.Element('chapter', title=title, fileName=self.file_name)
    for item in self.items:
      out.append(item.toXML())
    return out
  @staticmethod
  def fromXML(tag):
    items = list()
    for item in tag:
      items.append(Sentence.fromXML(item))
    title = tag.get('title')
    file_name = tag.get('fileName')
    return Chapter(title, file_name, items)

class Metadata(typing.NamedTuple):
  id: str
  title: str
  cover: bytes
  author: str
  def toXML(self):
    import base64
    out = xml.Element('meta')
    xml.SubElement(out, 'id').text = self.id
    xml.SubElement(out, 'title').text = self.title
    xml.SubElement(out, 'author').text = self.author
    if self.cover is not None:
      xml.SubElement(out, 'cover').text = base64.standard_b64encode(self.cover).decode('utf-8')
    return out

  @staticmethod
  def fromXML(tag):
    id = tag.find('id').text
    title = tag.find('title').text
    author = tag.find('author').text
    cover_raw = tag.find('cover')
    cover = None
    if cover_raw is not None:
      import base64
      cover = base64.standard_b64decode(cover_raw.text)
    return Metadata(id, title, cover, author)

class Book:
  def __init__(self, meta):
    self.meta = meta
    self.chapters = list()
  def toJSON(self):
    return json.dumps(self.__dict__)
  def toXML(self):
    out = xml.Element('book')
    out.append(self.meta.toXML())
    chapstag = xml.Element('chapters')
    for chap in self.chapters:
      chapstag.append(chap.toXML())
    out.append(chapstag)
    return xml.tostring(out, encoding='utf8', method='xml')
  @staticmethod
  def fromXML(buf):
    root = xml.fromstring(buf)
    metatag = root.find('meta')
    meta = Metadata.fromXML(metatag)
    chapstag = root.find('chapters')
    chapters = list()
    for chap in chapstag:
      chapters.append(Chapter.fromXML(chap))
    out = Book(meta)
    out.chapters = chapters
    return out