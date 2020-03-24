from ebooklib import epub
import mimetypes
import uuid
import re
import mimetypes
from urllib.parse import urlparse

from . import Metadata, Chapter, Sentence

from nltk.tokenize import sent_tokenize
from inscriptis import get_text
import json

def convert_epub(book):
    import nltk
    nltk.download('punkt')
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
            if cover_image is not None:
                coverType = mimetypes.guess_type(cover_image.file_name)[0]
                cover = base64.b64encode(cover_image.get_content()).decode('utf-8')
            else:
                cover = ''
    title = book.get_metadata('DC', 'title')[0][0]
    author = book.get_metadata('DC', 'creator')[0][0]
    meta = Metadata(0, title, cover, author, coverType)
    return meta, _book_to_chapters(book)


def _get_contents(book):
    out = map(lambda item: {'content': get_text(item.get_content().decode('utf-8')), 'name': item.file_name},
              filter(lambda item: isinstance(item, epub.EpubHtml), book.items)
              )
    return list(out)

def _flatten(items):
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
            out.extend(_flatten(subsection))
        elif isinstance(item, epub.Link):
            out.append({'title': item.title, 'href': item.href})
        elif isinstance(item, epub.EpubHtml):
            out.append({'title': item.title, 'href': item.file_name})
    for item in out:
        u = urlparse(item['href'])
        item['href'] = u.netloc + u.path
    return out

def _book_to_chapters(book):
    chaps = _flatten(book.toc)
    contents = _get_contents(book)
    for chap in chaps:
        for content in contents:
            if chap['href'] == content['name']:
                content['chapter'] = chap['title']
    out = list()
    for content in contents:
        content['sentences'] = _content_to_sentences(content['content'])
        if 'chapter' not in content:
            content['chapter'] = None
        out.append(Chapter(str(uuid.uuid1()), content['chapter'], content['name'], content['sentences']))
    return out

def _content_to_sentences(content):
    raw = content.split('\n')
    raw = filter(lambda item: len(re.sub(r'[\s+]', '', item)) != 0, raw)
    raw = map(lambda item: item.strip(' \t\n\r'), raw)
    raw = list(raw)
    out = list()
    for sen in raw:
        sens = sent_tokenize(sen)
        for i in range(0, len(sens)):
            if i == 0:
                out.append(Sentence(str(uuid.uuid1()), True, sens[i]))
            else:
                out.append(Sentence(str(uuid.uuid1()), False, sens[i]))
    return out