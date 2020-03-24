import sys

from gorani.booky.book import Book
from metaflow import FlowSpec, step, Parameter, JSONType, IncludeFile
import firebase_admin
import json
from firebase_admin import credentials
from firebase_admin import firestore
from google.cloud import bigquery
import urllib.request
import datetime

TABLE_ID = "goranireader.raw_event_logs"

class DownlodLog(FlowSpec):
    firebase_key = IncludeFile(
        'firebase-key',
        is_text=False,
        help='Firebase Key File',
        default='./firebase-key.json')

    storage_key = IncludeFile(
        'storage-key',
        is_text=False,
        help='Google Storage Key File',
        default='./storage-key.json')

    first_time = Parameter(
        'first-time',
        help='First Time',
        default='2019-03-22T21:38:00+00:00')

    @step
    def start(self):
        self.next(self.download_firebase)

    @step
    def download_firebase(self):
        with open('/tmp/firebase-key.json', 'wb') as f:
            f.write(self.firebase_key)
        cred = credentials.Certificate('/tmp/firebase-key.json')
        firebase_admin.initialize_app(cred, {
            'projectId': "gorani-reader-249509",
        })

        db = firebase_admin.firestore.client()
        self.download_books(db)
        self.download_users(db)

        self.next(self.download_logs)

    @step
    def download_logs(self):
        with open('/tmp/storage-key.json', 'wb') as f:
            f.write(self.storage_key)

        client = bigquery.Client.from_service_account_json(
            '/tmp/storage-key.json')

        rows_iter = client.list_rows(TABLE_ID)
        rows = list(rows_iter)
        def to_dict(row):
            out = dict()
            for key in row.keys():
                out[key] = row[key]
            return out
        self.logs = [to_dict(row) for row in rows]
        self.next(self.end)

    def download_books(self, db):
        self.books = dict()
        docs = db.collection("books").stream()
        for doc in docs:
            response = urllib.request.urlopen(doc.to_dict()['downloadLink'])
            data = json.load(response)
            book = Book.from_dict(data)
            self.books[doc.id] = book

    def download_users(self, db):
        self.users = dict()
        docs = db.collection('users').stream()
        for doc in docs:
            user = doc.to_dict()
            self.users[doc.id] = user
    @step
    def end(self):
        print('end')


if __name__ == '__main__':
    DownlodLog()
