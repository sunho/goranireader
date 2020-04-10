import boto3
from botocore.exceptions import ClientError
from dataserver.utils import split_sentence, unnesting
from metaflow import FlowSpec, step, Flow, IncludeFile, conda_base
import pandas as pd
import json
import uuid
import typing
import numpy as np
from dataserver.booky import Book
from pandas import DataFrame
from send import log_msg
import time
from datetime import datetime, timedelta
from pytz import timezone, utc
import pandera as pa
from dataserver.utils import pip

@conda_base(libraries= {
    'boto3': '1.12',
    'booky': '1.0.5',
    'pandera': '0.3.2',
    'rsa': '4.0'
})
class GenerateReview(FlowSpec):
    firebase_key = IncludeFile(
        'firebase-key',
        is_text=False,
        help='Firebase Key File',
        default='./firebase-key.json')

    @step
    def start(self):
        flow = Flow('DownloadLog').latest_successful_run
        print('using data from flow: %s' % flow.id)
        self.users = flow.data.users

        flow = Flow('PreprocessPaginate').latest_successful_run
        print('using data from flow: %s' % flow.id)
        self.session_info_df = flow.data.session_info_df
        self.clean_pages_df = flow.data.clean_pages_df
        self.signals_df = flow.data.signals_df
        self.last_words_after_hours = 12
        self.skip_session_hours = 0.1
        self.last_stats_days = 14

        self.next(self.preprocess)

    @step
    def preprocess(self):
        pass

    @pip(libraries={
        'firebase-admin': '4.0.1'
    })
    @step
    def upload(self):
        import firebase_admin
        from firebase_admin import credentials
        from firebase_admin import firestore
        with open('/tmp/firebase-key.json', 'wb') as f:
            f.write(self.firebase_key)
        cred = credentials.Certificate('/tmp/firebase-key.json')
        firebase_admin.initialize_app(cred, {
            'projectId': "booky-reader-249509"
        })
        out = []
        db = firebase_admin.firestore.client()
        bucket_name = 'gorani-reader-generated-reviews'
        s3 = boto3.resource("s3")
        for _, row in self.review_df.iterrows():
            review = json.loads(row['review'])
            filename = row['userId'] + '-' + str(review['end']) + '.json'
            try:
                s3.Object(bucket_name, filename).load()
            except ClientError as e:
                if e.response['Error']['Code'] == "404":
                    out.append(row['userId'])
                    s3.Object(bucket_name, filename).put(Body=json.dumps(review))
                    url = "https://" + bucket_name + ".s3.ap-northeast-2.amazonaws.com/" + filename
                    ref = db.collection('users').document(row['userId'])
                    ref.set({
                        'review': url
                    }, merge=True)
                else:
                    raise
        self.added = out
        self.next(self.end)

    @step
    def end(self):
        log_msg('./generate_review.py', '\n'.join(self.added), False)

if __name__ == '__main__':
    GenerateReview()