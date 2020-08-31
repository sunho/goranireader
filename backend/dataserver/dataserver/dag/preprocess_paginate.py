from metaflow import FlowSpec, step, Flow, IncludeFile, conda_base
import pandas as pd

from dataserver.job.preprocess_pages import preprocess_paginate_logs, \
    extract_signals_df, clean_signals_df, clean_pages_df

from dataserver.dag import deps

import yaml

from dataserver.models.config import Config
from dataserver.service import BookService
from dataserver.service.nlp import NLPService
from dataserver.dag import GoraniFlowSpec

class PreprocessPaginate(GoraniFlowSpec):
    @step
    def start(self):
        flow = Flow('DownloadLog').latest_successful_run
        print('using data from flow: %s' % flow.id)

        self.books = flow.data.books
        self.logs = flow.data.logs
        self.config = Config(**yaml.load(self.config_file))

        self.next(self.preprocess_pages_df)

    @step
    def preprocess_pages_df(self):
        logs_df = pd.DataFrame(self.logs)
        logs_df = logs_df.loc[logs_df['type'] == 'paginate']

        nlp_service = NLPService()
        nlp_service.download_data()
        book_service = BookService(self.books.values())
        self.pages_df = preprocess_paginate_logs(logs_df, nlp_service, book_service, self.config)

        self.next(self.extract_signals_df)

    @step
    def extract_signals_df(self):
        self.signals_df = extract_signals_df(self.pages_df)

        self.next(self.clean_dfs)

    @step
    def clean_dfs(self):
        nlp_service = NLPService()
        nlp_service.download_data()

        book_service = BookService(self.books.values())

        self.clean_signals_df = clean_signals_df(self.signals_df, nlp_service)
        self.clean_pages_df = clean_pages_df(self.pages_df, book_service)

        self.next(self.end)

    @step
    def end(self):
        pass

if __name__ == '__main__':
    PreprocessPaginate()