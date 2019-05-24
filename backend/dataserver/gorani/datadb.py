#
# Copyright © 2019 Sunho Kim. All rights reserved.
#

from cassandra.cluster import Cluster
from cassandra import query
import pickle

class DataDB:
    def __init__(self):
        self._cluster = Cluster()
        self._session = self._cluster.connect('gorani')

    def get_book_ids(self):
        return map(lambda r: r.id,
        self._session.execute('select id from books').current_rows)

    def get_all(self, table):
        return self._session.execute('select * from {}'.format(table))

    def get_user_known_words(self, user_id: int):
        ws = self._session.execute('select * from user_known_words where user_id = %s and score > 1 allow filtering', (user_id, )).current_rows
        return [w.word for w in ws]

    def get_flipped_paragraphs(self, user_id: int):
        ps = self._session.execute('select * from user_flipped_paragraphs where user_id = %s', (user_id, )).current_rows
        out = list()
        for p in ps:
            out.append({
                'interval': p.interval,
                'time': p.time,
                'paragraph': pickle.loads(p.paragraph)
            })
        return out

    def delete_book(self, id):
        self._session.execute('delete from books where id = %s', (id, ))
        self._session.execute('delete from book_words where book_id = %s', (id, ))
