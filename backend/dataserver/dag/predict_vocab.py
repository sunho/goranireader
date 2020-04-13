from metaflow import FlowSpec, step, Flow, IncludeFile, conda_base, batch
import pandas as pd

from dataserver.job.ml import predict_vocab
from dataserver.job.prepare_features import prepare_simple_features, prepare_series_features, split_simple_features
from dataserver.job.preprocess_pages import preprocess_paginate_logs, \
    extract_signals_df, clean_signals_df, clean_pages_df

from dag.deps import deps

import yaml

from dataserver.models.config import Config
from dataserver.service import BookService
from dataserver.service.nlp import NLPService
from dataserver.service.notification import NotificationService


@conda_base(libraries=deps)
class PredictVocab(FlowSpec):
    config_file = IncludeFile(
        'config',
        is_text=False,
        help='Config Key File',
        default='./config.yaml')

    @step
    def start(self):
        flow = Flow('PreprocessPaginate').latest_successful_run
        print('using data from flow: %s' % flow.id)

        self.signals = flow.data.signals_df

        flow = Flow('PrepareFeatures').latest_successful_run
        print('using data from flow: %s' % flow.id)

        self.features = flow.data.recent_annoated_simple_features

        flow = Flow('DeployModel').latest_successful_run
        print('using data from flow: %s' % flow.id)

        self.model = flow.data.model
        self.config = Config(**yaml.load(self.config_file))

        self.next(self.predict_vocab)

    @step
    def predict_vocab(self):
        nlp_service = NLPService()
        known_words_df, unknown_words_df = predict_vocab(self.features, self.signals, self.model, nlp_service)

        self.unknown_words_df = unknown_words_df
        self.known_words_df = known_words_df

        self.next(self.end)

    @step
    def end(self):
        service = NotificationService(self.config)
        service.complete_flow("Predict Vocab", 'yeah', False)

if __name__ == '__main__':
    PredictVocab()