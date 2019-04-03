from gorani.shared import TFJob, TFJobContext
from . import PrepareTimeDataset
from gorani.shared.tfmodels import TimeModel

class TrainTimeModel(TFJob):
    def __init__(self, context: TFJobContext):
        TFJob.__init__(self, context)

    def train(self):
        job = PrepareTimeDataset(self.context)
        ps = self.context.data_db.get_flipped_paragraphs(1)
        x, y = job.transform_paragraphs(ps)
        model = TimeModel()
        model.compile(loss='mse', optimizer='adam')
        model.fit(X, y, epochs=1000, verbose=1)
