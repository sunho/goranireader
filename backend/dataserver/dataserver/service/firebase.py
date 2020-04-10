

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

from dataserver.models.config import Config
import urllib.request
import json
from dataserver.booky import Book

class FirebaseService:
    def __init__(self, config: Config):
        cred = credentials.Certificate(config.firebase_cert)
        firebase_admin.initialize_app(cred, {
            'projectId': config.firebase_project_id
        })
        self.db = firebase_admin.firestore.client()

    def fetch_books(self):
        books = dict()
        docs = self.db.collection("books").stream()
        for doc in docs:
            response = urllib.request.urlopen(doc.to_dict()['downloadLink'])
            data = json.load(response)
            book = Book.from_dict(data)
            books[doc.id] = book
        return books

    def fetch_users(self):
        users = dict()
        docs = self.db.collection('users').stream()
        for doc in docs:
            user = doc.to_dict()
            users[doc.id] = user
        return users

    def update_user(self, user_id, obj):
        ref = self.db.collection('users').document(user_id)
        ref.set(obj, merge=True)
