import tensorflow as tf
from tensorflow.keras.layers import LSTM, Dense, Input

class TimeModel(tf.keras.Model):
    def __init__(self, feature_length: int):
        super(TimeModel, self).__init__(name='Time Model')
        self.feature_length = feature_length
        self.lstm = LSTM(32)
        self.dense1 = Dense(32, activation='relu')
        self.dense2 = Dense(1)

    def call(self, inputs):
        x = self.lstm(inputs)
        x = self.dense1(x)
        return self.dense2(x)
