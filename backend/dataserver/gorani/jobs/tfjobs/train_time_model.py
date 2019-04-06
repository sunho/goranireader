from gorani.shared import TFJob, TFJobContext
from . import PrepareTimeDataset
from .prepare_time_dataset import FEATURE_LEN
from gorani.shared.tfmodels import TimeModel
from tensorflow import keras

class TrainTimeModel(TFJob):
    def __init__(self, context: TFJobContext):
        TFJob.__init__(self, context)

    def train(self):
        job = PrepareTimeDataset(self.context)
        cb = keras.callbacks.TensorBoard(log_dir='/gorani/graph', histogram_freq=0,
          write_graph=True, write_images=True)
        ps = self.context.data_db.get_flipped_paragraphs(1)
        x, y = job.transform_paragraphs(ps)
        model = TimeModel(FEATURE_LEN)
        model.compile(loss='mse', optimizer='adam', metrics=['accuracy'])
        model.fit(x, y, batch_size = 60, epochs=1000, verbose=1, callbacks=[cb], validation_data = (x_test, y_test))
