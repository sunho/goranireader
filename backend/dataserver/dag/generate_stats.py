import boto3
from botocore.exceptions import ClientError
from metaflow import FlowSpec, step, Flow, IncludeFile, conda_base
import pandas as pd
import json
import uuid
import typing
import numpy as np
from dataserver.booky import Book
from pandas import DataFrame
import time
from datetime import datetime, timedelta
from pytz import timezone, utc
import pandera as pa
from dag.decorators import pip

LastSessionDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "session": pa.Column(pa.Int),
}, strict=True)

LastWordsDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "session": pa.Column(pa.Int),
    "lastWords": pa.Column(pa.String),
    "targetLastWords": pa.Column(pa.Int)
}, strict=True)

StatsDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "stats": pa.Column(pa.String)
}, strict=True)

ReviewDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "review": pa.Column(pa.String)
}, strict=True)

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
    def end(self):
        print(self.review_df[['userId']])

if __name__ == '__main__':
    GenerateReview()