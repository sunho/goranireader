from metaflow import FlowSpec, step, Flow, IncludeFile, conda_base, batch
import pandas as pd

from dataserver.job.prepare_features import prepare_simple_features, prepare_series_features, annotate_simple_features
from dataserver.job.preprocess_pages import preprocess_paginate_logs, \
    extract_signals_df, clean_signals_df, clean_pages_df


from dag.deps import deps

import yaml

from dataserver.models.config import Config
from dataserver.service import BookService
from dataserver.service.nlp import NLPService
from dataserver.service.notification import NotificationService


@conda_base(libraries=deps)
class PrepareFeatures(FlowSpec):
    config_file = IncludeFile(
        'config',
        is_text=False,
        help='Config Key File',
        default='./config.yaml')

    @step
    def start(self):
        flow = Flow('PreprocessPaginate').latest_successful_run
        print('using data from flow: %s' % flow.id)

        self.signals_df = flow.data.signals_df
        self.clean_signals_df = flow.data.clean_signals_df
        self.config = Config(**yaml.load(self.config_file))

        self.next(self.prepare_simple_features)

    @step
    def prepare_simple_features(self):
        self.clean_simple_features = prepare_simple_features(self.clean_signals_df)
        self.simple_features  = prepare_simple_features(self.signals_df)

        self.clean_series_features = prepare_series_features(self.clean_signals_df)
        self.series_features = prepare_series_features(self.signals_df)

        import pyphen
        dic = pyphen.Pyphen(lang='en_US')

        import gensim
        vec_model = gensim.models.KeyedVectors.load_word2vec_format('GoogleNews-vectors-negative300.bin', binary=True)

        self.annoated_simple_features = annotate_simple_features(self.clean_simple_features, vec_model, dic)

        self.next(self.end)

    @step
    def end(self):
        service = NotificationService(self.config)
        service.complete_flow("Prepare Features", 'yeah', False)

if __name__ == '__main__':
    PrepareFeatures()