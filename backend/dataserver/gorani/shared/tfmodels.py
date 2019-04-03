import tensorflow as tf
from tensorflow.keras.layers import LSTM, Dense, Input

class TimeModel(tf.keras.Sequential):
    def __init__(self, feature_length: int):
        super(TimeModel, self).__init__()
        self.feature_length = feature_length
        self.add(Input(shape=(None, feature_length)))
        self.add(LSTM(256))
        self.add(Dense(128))
        self.add(Dense(1, activation='linear'))
