from metaflow import FlowSpec, step, Flow, IncludeFile, conda_base

from dataserver.dag import deps, GoraniFlowSpec

import yaml

from dataserver.models.config import Config


class DeployModel(GoraniFlowSpec):
    @step
    def start(self):
        flow = Flow('TrainModels').latest_successful_run
        print('using data from flow: %s' % flow.id)

        self.model = flow.data.simple_rf
        self.config = Config(**yaml.load(self.config_file))

        self.next(self.end)

    @step
    def end(self):
        pass

if __name__ == '__main__':
    DeployModel()