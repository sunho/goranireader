from typing import NamedTuple
from enum import Enum
import io
import joblib

class ModelType(Enum):
    XGBOOST = "xgboost"

class Model(NamedTuple):
    created_at: float
    name: str
    feature_type: str
    last_feature_time: int
    type: ModelType
    payload: bytes

    def get_classifier(self):
        if self.type == ModelType.XGBOOST:
            return joblib.load(io.BytesIO(self.payload))
