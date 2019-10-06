import json
import sys

class Gorani:
    def __init__(self, db):
        self.chapters = dict()
        self.usernames = dict()
        self.contents = dict()
        self.sentences = dict()
        self.book_rows = list()
        self.questions = dict()
        self.books = dict()
        self.init_books(db)

    def init_books(self, db):
        docs = db.collection("books").stream()
        for doc in docs:
            if sys.version_info >= (3,6,0):
                import urllib.request
                response =  urllib.request.urlopen(doc.to_dict()['downloadLink'])
            else:
                import urllib2
                response = urllib2.urlopen(doc.to_dict()['downloadLink'])
            data = json.load(response)
            self.books[doc.id] = data
            self.contents[doc.id] = dict()
            self.sentences[doc.id] = dict()
            self.questions[doc.id] = dict()
            for chap in data['chapters']:
                self.contents[doc.id][chap['id']] = dict()
                self.sentences[doc.id][chap['id']] = dict()
                if 'questions' in chap:
                    self.questions[doc.id][chap['id']] = chap['questions']
                if chap['title'] == '':
                    self.chapters[chap['id']] = '(blank)'
                else:
                    self.chapters[chap['id']] = chap['title']
                def get_surrounding_text(senid):
                    for i in range(0, len(chap['items'])):
                        if chap['items'][i]['id'] == senid:
                            return ' '.join(s['content'] for s in chap['items'][max(0,i-3):min(len(chap['items']),i+3)])
                    raise Exception("wtf")
                for item in chap['items']:
                    self.sentences[doc.id][chap['id']][item['id']] = item['content']
                    self.contents[doc.id][chap['id']][item['id']] = get_surrounding_text(item['id'])

        docs = db.collection('users').stream()
        for doc in docs:
            user = doc.to_dict()
            self.usernames[doc.id] = user.get('username', '')

    def get_username(self, user_id):
        return self.usernames.get(user_id, None)

    def get_sentence(self, book_id, chapter_id, sid):
        return self.sentences.get(book_id, {}).get(chapter_id, {}).get(sid, None)

    def get_content(self, book_id, chapter_id, sid):
        return self.contents.get(book_id, {}).get(chapter_id, {}).get(sid, None)

    def get_chapter_name(self, chapter_id):
        return self.chapters.get(chapter_id, None)

    def get_questions(self, book_id, chapter_id):
        return self.questions.get(book_id, {}).get(chapter_id, None)


