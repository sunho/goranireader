import sys

from dataserver.booky.book import Book
from metaflow import FlowSpec, step, Parameter, JSONType, IncludeFile, conda_base

import json

import urllib.request
import boto3
from concurrent import futures
from dataserver.utils import pip
import pandas as pd
from send import log_msg
import datetime

@conda_base(libraries= {
    'boto3': '1.12',
    'booky': '1.0.5',
    'pandera': '0.3.2',
    'rsa': '4.0'
})
class DownloadLog(FlowSpec):
    firebase_key = IncludeFile(
        'firebase-key',
        is_text=False,
        help='Firebase Key File',
        default='./firebase-key.json')

    first_time = Parameter(
        'first-time',
        help='First Time',
        default='2019-03-22T21:38:00+00:00')

    @step
    def start(self):
        self.next(self.download_firebase)

    @pip(libraries={
        'firebase-admin': '4.0.1'
    })
    @step
    def download_firebase(self):
        import firebase_admin
        from firebase_admin import credentials
        from firebase_admin import firestore
        with open('/tmp/firebase-key.json', 'wb') as f:
            f.write(self.firebase_key)
        cred = credentials.Certificate('/tmp/firebase-key.json')
        firebase_admin.initialize_app(cred, {
            'projectId': "booky-reader-249509",
        })

        db = firebase_admin.firestore.client()
        self.download_books(db)
        self.download_users(db)

        self.next(self.download_logs)

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
    def download_logs(self):
        rows = []
        for row in self.fetch_all():
            rows.append(row)
        self.logs = rows
        self.next(self.end)

    def fetch_all(self):
        s3 = boto3.client("s3")
        bucket_name = "booky-reader-client-event-logs"
        s3_result = s3.list_objects_v2(Bucket=bucket_name)
        file_list = []
        if 'Contents'  in s3_result:
            for key in s3_result['Contents']:
                file_list.append(key['Key'])

            while s3_result['IsTruncated']:
                continuation_key = s3_result['NextContinuationToken']
                s3_result = s3.list_objects_v2(Bucket=bucket_name,
                                                    ContinuationToken=continuation_key)
                for key in s3_result['Contents']:
                    file_list.append(key['Key'])

        def fetch(key):
            obj = s3.get_object(Bucket=bucket_name, Key=key)
            obj_df = json.load(obj["Body"])
            return obj_df

        with futures.ThreadPoolExecutor(max_workers=5) as executor:
            future_to_key = {executor.submit(fetch, key): key for key in file_list}

            for future in futures.as_completed(future_to_key):
                exception = future.exception()

                if not exception:
                    yield future.result()
                else:
                    yield exception

    @step
    def end(self):
        log_msg('./download_log.py', 'processed: %d' % len(self.logs), False)


if __name__ == '__main__':
    DownloadLog()
