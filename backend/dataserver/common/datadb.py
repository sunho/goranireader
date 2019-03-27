from cassandra.cluster import Cluster
from cassandra import query

class DataDB:
    def __init__(self):
        self._cluster = Cluster()
        self._session = self._cluster.connect('gorani')

    def get_book_ids(self):
        return map(lambda r: r.id,
        self._session.execute('select id from books').current_rows)

    def get_all(self, table):
        return self._session.execute('select * from {}'.format(table))

    def delete_book(self, id):
        self._session.execute('delete from books where id = %s', (id, ))
        self._session.execute('delete from book_words where book_id = %s', (id, ))
