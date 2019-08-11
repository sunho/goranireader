import book as mbook
import msgpack

buf = None
with open('out.xml', 'r') as f:
  buf = f.read()
book = mbook.Book.fromXML(buf)
buf = msgpack.packb(book.__dict__)
with open('out.book', 'wb') as f:
  f.write(buf)
