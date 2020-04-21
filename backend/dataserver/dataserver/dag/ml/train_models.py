from metaflow import FlowSpec, step, Flow, IncludeFile, conda_base

from dataserver.job.ml import train_simple_rf

from dataserver.dag import deps, GoraniFlowSpec

import yaml

from dataserver.models.config import Config
from dataserver.job.prepare_features import split_simple_features, get_last_input_time


class TrainModels(GoraniFlowSpec):
    @step
    def start(self):
        flow = Flow('PrepareFeatures').latest_successful_run
        print('using data from flow: %s' % flow.id)

        self.fetures = flow.data.annoated_simple_features

        self.config = Config(**yaml.load(self.config_file))

        self.next(self.train_simple_rf_model)

    @step
    def train_simple_rf_model(self):
        x, y, meta_df = split_simple_features(self.fetures)
        last_time = get_last_input_time(meta_df)
        print(self.fetures.columns)
        self.simple_rf = train_simple_rf(x, y, 'annotated_simple', last_time)

        self.next(self.end)

    @step
    def end(self):
        pass

if __name__ == '__main__':
    TrainModels()