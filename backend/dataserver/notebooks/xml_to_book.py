import gorani.models.book as mbook
import simplejson

buf = None
bookname='book2'
with open(bookname+'.xml', 'r') as f:
  buf = f.read()
book = mbook.Book.fromXML(buf)
buf = simplejson.dumps(book.__dict__)
with open(bookname+'.book', 'wb') as f:
  f.write(buf.encode('utf-8'))
