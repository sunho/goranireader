from metaflow import FlowSpec, step, Flow, IncludeFile, conda_base

from dataserver.dag import deps

import yaml

from dataserver.models.config import Config
from dataserver.service.notification import NotificationService


@conda_base(libraries=deps)
class DeployModel(FlowSpec):
    config_file = IncludeFile(
        'config',
        is_text=False,
        help='Config Key File',
        default='./config.yaml')

    @step
    def start(self):
        flow = Flow('TrainModels').latest_successful_run
        print('using data from flow: %s' % flow.id)

        self.model = flow.data.simple_rf
        self.config = Config(**yaml.load(self.config_file))

        self.next(self.end)

    @step
    def end(self):
        service = NotificationService(self.config)
        service.complete_flow("DeployModels", 'yay', False)

if __name__ == '__main__':
    DeployModel()