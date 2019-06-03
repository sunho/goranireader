#
# Copyright © 2019 Sunho Kim. All rights reserved.
#

from cassandra.cluster import Cluster
from cassandra import query
import pickle

class DataDB:
    def __init__(self, addr='127.0.0.1', port=None):
        if port is not None:
            self._cluster = Cluster([addr], port=port)
        else:
            self._cluster = Cluster([addr])
        self._session = self._cluster.connect('gorani')

    def get_book_ids(self):
        return map(lambda r: r.id, self._session.execute('select id from books').current_rows)

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

    def add_book_estimated_time(self, user_id, book_id, words, time):
        self._session.execute('insert into book_estimated_time(user_id, book_id, total_words, estimated_time) values(%s, %s, %s, %s)', (user_id, book_id, words, time))

