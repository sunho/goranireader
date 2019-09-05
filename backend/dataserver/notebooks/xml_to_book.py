import gorani.models.book as mbook
import simplejson

buf = None
with open('out.xml', 'r') as f:
  buf = f.read()
book = mbook.Book.fromXML(buf)
buf = simplejson.dumps(book.__dict__)
with open('out.book', 'wb') as f:
  f.write(buf.encode('utf-8'))
