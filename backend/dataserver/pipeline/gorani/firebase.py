import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import storage


def init():
    cred = credentials.Certificate("key.json")
    firebase_admin.initialize_app(cred, {
        'projectId': "gorani-reader-249509",
    })


def db():
    return firebase_admin.firestore.client()
