from metaflow import FlowSpec, step, Flow, IncludeFile, conda_base

from dataserver.job.ml import train_simple_rf

from dataserver.dag import deps

import yaml

from dataserver.models.config import Config
from dataserver.service.notification import NotificationService
from dataserver.job.prepare_features import split_simple_features, get_last_input_time


@conda_base(libraries=deps)
class TrainModels(FlowSpec):
    config_file = IncludeFile(
        'config',
        is_text=False,
        help='Config Key File',
        default='./config.yaml')

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
        service = NotificationService(self.config)
        service.complete_flow("Train Models", 'Yay', False)

if __name__ == '__main__':
    TrainModels()