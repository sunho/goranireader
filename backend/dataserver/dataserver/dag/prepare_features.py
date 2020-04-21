from metaflow import FlowSpec, step, Flow, IncludeFile, conda_base

from dataserver.job.prepare_features import prepare_simple_features, annotate_simple_features, extract_recent_features

from dataserver.dag import deps, GoraniFlowSpec

import yaml

from dataserver.models.config import Config
from dataserver.service.nlp import NLPService

class PrepareFeatures(GoraniFlowSpec):
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
        nlp_service = NLPService()
        nlp_service.download_data()

        import pyphen
        dic = pyphen.Pyphen(lang='en_US')

        import gensim
        vec_model = gensim.models.KeyedVectors.load_word2vec_format('GoogleNews-vectors-negative300.bin', binary=True)

        self.clean_simple_features = prepare_simple_features(self.clean_signals_df, nlp_service)
        # self.simple_features  = prepare_simple_features(self.signals_df, nlp_service)

        # self.clean_series_features = prepare_series_features(self.clean_signals_df)
        # self.series_features = prepare_series_features(self.signals_df)


        self.annoated_simple_features = annotate_simple_features(self.clean_simple_features,
                                                                 vec_model, dic, k=self.config.word2vec_k)
        self.recent_annoated_simple_features = extract_recent_features(self.annoated_simple_features)

        self.next(self.end)

    @step
    def end(self):
        pass

if __name__ == '__main__':
    PrepareFeatures()