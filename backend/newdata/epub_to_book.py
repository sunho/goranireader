from nltk.tokenize import sent_tokenize
from ebooklib import epub
from inscriptis import get_text
from urllib.parse import urlencode, urlparse, urlunparse, parse_qs
import book as mbook
import uuid
import re
import ast
import nltk
nltk.download('punkt')

MIN_SEN_LEN = 30

def get_contents(book):
  out = map(lambda item: {'content': get_text(item.get_content().decode('unicode_escape')), 'name': item.file_name},
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
      else:
        content['chapter'] = ''
  content['sentences'] = content_to_sentences(content['content'])
  out = list()
  for content in contents:
    out.append(mbook.Chapter(content['chapter'], content['name'], content['sentences']))
  return contents

def content_to_sentences(content):
  raw = content.split('\n')
  raw = filter(lambda item: len(re.sub(r'[\s+]', '',item)) != 0, raw)
  raw = map(lambda item: item.strip(' \t\n\r'), raw)
  raw = list(raw)
  sens = list()
  for sen in raw:
    sens.extend(sent_tokenize(sen))
  out = list()
  for sen in sens:
    out.append(mbook.Sentence(str(uuid.uuid1()), sen))
  return out

def convert_book(book):
  book.
  out = mbook.Book()

book = epub.read_epub('test.epub')
chaps = book_to_chapters(book)