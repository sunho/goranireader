from dataserver.job.utils import unnesting
from metaflow import FlowSpec, step, Flow, IncludeFile, conda_base, batch
import pandas as pd
import json
import typing
import numpy as np
from dataserver.booky import Book
from dataserver.job.preprocess_pages import preprocess_paginate_logs, extract_signals_df

import nltk
import yaml
from nltk import pos_tag

from dataserver.models.config import Config
from dataserver.service import BookService
from dataserver.service.nlp import NLPService


@conda_base(libraries= {
    'boto3': '1.12',
    'booky': '1.0.5',
    'pandera': '0.3.2',
    'rsa': '4.0'
})
class PreprocessPaginate(FlowSpec):
    config_file = IncludeFile(
        'config',
        is_text=False,
        help='Firebase Key File',
        default='./config.yaml')

    @step
    def start(self):
        flow = Flow('DownloadLog').latest_successful_run
        print('using data from flow: %s' % flow.id)
        self.books = flow.data.books
        self.logs = flow.data.logs

        self.filter_wpm_threshold = 1000
        self.cluster_threshold = 6.5
        self.max_session_hours = 12
        self.cheat_eltime_threshold = 11

        self.config = Config(**yaml.load(self.config_file))

        self.next(self.preprocess_pages_df)

    @step
    def preprocess_pages_df(self):
        logs_df = pd.DataFrame(self.logs)

        nlp_service = NLPService()
        book_service = BookService(self.books.values())
        self.pages_df = preprocess_paginate_logs(logs_df, nlp_service, book_service, self.config)

        self.next(self.extract_signals_df)

    @step
    def extract_signals_df(self):
        nltk.download('stopwords')
        nlp_service = NLPService()

        self.signals_df = extract_signals_df(self.pages_df, )
        self.next(self.make_clean_pages_df)

    @step
    def clean_dfs(self):
        self.clean_ = self.clean_pages_df(self.pages_df)

    @step
    def extract_session_info_df(self):


        self.session_info_df = SessionInfoDataFrame.validate(df3)
        self.next(self.end)
    @step
    def end(self):
        log_msg('./preprocess_paginate.py', 'processed: %d' % self.signals_df.size, False)

if __name__ == '__main__':
    PreprocessPaginate()