from dataserver.models.config import Config
from dataserver.service.firebase import FirebaseService

import msgpack

def run(config: Config):
    serv = FirebaseService(config)
    books = serv.fetch_books()
    users = serv.fetch_users()
    
    data = dict()
    data['books'] = books
    data['users'] = users
    data['vocab_skills'] = config.


    data = msgpack.unpackb(self.data_file)
    self.logs = data['logs']
    self.users = data['users']

    self.books = [Book.from_dict(book) for book in data['books']]
    self.vocab_skills = [VocabSkill(**vc) for vc in data['vocab_skills']]