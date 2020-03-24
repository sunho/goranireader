from gorani.booky.book import from_dict
from metaflow import FlowSpec, step, Parameter, JSONType, IncludeFile
import firebase_admin
import json
from firebase_admin import credentials
from firebase_admin import firestore
import urllib.request
import datetime

BUCKET = 'gorani-reader-249509-gorani-reader-event-log'

def process(input):
    name, first_time, i = input[0], input[1], input[2]
    print(i)
    from dateutil.parser import parse
    import json
    from google.cloud import storage
    store = storage.Client.from_service_account_json(
        '/tmp/storage-key.json')
    arr = name.split('$')
    if len(arr) < 5:
        return None
    t = arr[4]
    if parse(t) < parse(first_time):
        return None
    bucket = store.bucket(BUCKET)
    blob = bucket.blob(name)
    data = json.loads(blob.download_as_string(client=None))
    sys.stdout.flush()
    return data

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
        logs = []
        from google.cloud import storage
        with open('/tmp/storage-key.json', 'wb') as f:
            f.write(self.storage_key)

        store = storage.Client.from_service_account_json(
            '/tmp/storage-key.json')

        bucket = store.get_bucket(BUCKET)
        blobs = list(bucket.list_blobs())
        print("len:", len(blobs))
        from multiprocessing import Pool
        pool = Pool(processes=10)
        logs = pool.map(process, [(blobs[i].name, self.first_time, i) for i in range(len(blobs))])
        pool.close()
        pool.join()
        self.logs = logs
        self.next(self.end)

    def download_books(self, db):
        self.books = dict()
        docs = db.collection("books").stream()
        for doc in docs:
            response = urllib.request.urlopen(doc.to_dict()['downloadLink'])
            data = json.load(response)
            book = from_dict(data)
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
