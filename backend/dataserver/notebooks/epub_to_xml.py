import uuid
import re
import nltk
import mimetypes
import gorani.models.book as mbook
from urllib.parse import urlparse
from nltk.tokenize import sent_tokenize
from ebooklib import epub
from inscriptis import get_text

nltk.download('punkt')

MIN_SEN_LEN = 30

def get_contents(book):
  out = map(lambda item: {'content': get_text(item.get_content().decode('utf-8')), 'name': item.file_name},
    filter(lambda item: isinstance(item, epub.EpubHtml), book.items)
  )
  return list(out)

def flatten(items):
  out = list()
  for item in items:
    if isinstance(item, tuple) or isinstance(item, list):
      section, subsection = item[0], item[1]
      href = ''
      if isinstance(section, epub.EpubHtml):
        href = section.get_id()
      elif isinstance(section, epub.Section) and section.href != '':
        href = section.href
      elif isinstance(section, epub.Link):
        href = section.href
      out.append({'title': section.title, 'href': href})
      out.extend(flatten(subsection))
    elif isinstance(item, epub.Link):
      out.append({'title': item.title, 'href': item.href})
    elif isinstance(item, epub.EpubHtml):
      out.append({'title': item.title, 'href': item.file_name})
  for item in out:
    u = urlparse(item['href'])
    item['href'] = u.netloc + u.path
  return out

def book_to_chapters(book):
  chaps = flatten(book.toc)
  contents = get_contents(book)
  for chap in chaps:
    for content in contents:
      if chap['href'] == content['name']:
        content['chapter'] = chap['title']
  out = list()
  for content in contents:
    content['sentences'] = content_to_sentences(content['content'])
    if 'chapter' not in content:
      content['chapter'] = None 
    out.append(mbook.Chapter(str(uuid.uuid1()), content['chapter'], content['name'], content['sentences']))
  return out

def content_to_sentences(content):
  raw = content.split('\n')
  raw = filter(lambda item: len(re.sub(r'[\s+]', '',item)) != 0, raw)
  raw = map(lambda item: item.strip(' \t\n\r'), raw)
  raw = list(raw)
  out = list()
  for sen in raw:
    sens = sent_tokenize(sen)
    for i in range(0, len(sens)):
      if i == 0:
        out.append(mbook.Sentence(str(uuid.uuid1()), True, sens[i]))
      else:
        out.append(mbook.Sentence(str(uuid.uuid1()), False, sens[i]))
  return out

def convert_book(book):
  import base64
  cover = None
  coverType = ''
  cover_image = book.get_item_with_id('cover-image')
  if cover_image is not None:
    coverType = mimetypes.guess_type(cover_image.file_name)[0]
    cover = base64.b64encode(cover_image.get_content()).decode('utf-8')
  else:
    cover_id = book.get_metadata('OPF', 'cover')
    if len(cover_id) != 0:
      cover_id = cover_id[0][1]['content']
      cover_image = book.get_item_with_id(cover_id)
      coverType = mimetypes.guess_type(cover_image.file_name)[0]
      cover = base64.b64encode(cover_image.get_content()).decode('utf-8')
  title = book.get_metadata('DC', 'title')[0][0]
  author = book.get_metadata('DC', 'creator')[0][0]
  meta = mbook.Metadata(0, title, cover, author, coverType)
  out = mbook.Book(meta)
  out.chapters = book_to_chapters(book)
  return out

book = epub.read_epub('test.epub')
from xml.dom import minidom
cbook = convert_book(book)
buf = minidom.parseString(cbook.toXML().decode('utf-8')).toprettyxml(indent="   ")
with open("out.xml", "w") as f:
  f.write(buf)