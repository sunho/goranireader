#
# Copyright © 2019 Sunho Kim. All rights reserved.
#

from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import GRU, Dense, Input, Dropout
from tensorflow.keras.callbacks import ModelCheckpoint
from tensorflow.keras.callbacks import TensorBoard

def time_model(feature_len, neuron, dropout):
    model = Sequential()
    model.add(GRU(neuron, input_shape=(None, feature_len), dropout=dropout, recurrent_dropout=dropout, kernel_initializer='he_uniform'))
    model.add(Dense(neuron, activation='relu'))
    model.add(Dense(1))
    return model

