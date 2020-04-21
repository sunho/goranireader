from metaflow import FlowSpec, step, Flow, IncludeFile, conda_base

from dataserver.job.ml import predict_vocab

from dataserver.dag import deps, GoraniFlowSpec

import yaml

from dataserver.models.config import Config
from dataserver.service.nlp import NLPService

class PredictVocab(GoraniFlowSpec):
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
        pass

if __name__ == '__main__':
    PredictVocab()