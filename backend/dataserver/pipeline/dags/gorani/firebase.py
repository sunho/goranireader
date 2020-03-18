import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import storage

def init(env):
    if env == 'func':
        from google.cloud import storage
        storage_client = storage.Client()
        bucket = storage_client.get_bucket("gorani-reader-airflow")
        blob = bucket.blob("key.json")
        blob.download_to_filename("key.json")
    cred = credentials.Certificate("key.json")
    firebase_admin.initialize_app(cred, {
        'projectId': "gorani-reader-249509",
    })
    print('Firebase inited')

def db():
    return firebase_admin.firestore.client()
