from metaflow import FlowSpec, IncludeFile, conda_base

deps = {
    'boto3': '1.12',
    "pyyaml": "5.3.1",
    'pandera': '0.3.2',
    "ebooklib": "0.17.1",
    "inscriptis": "1.0",
    "nltk": "3.4.5",
    "pandas": "1.0.3",
    "xgboost": "1.0.2",
    "scikit-learn": "0.22.1",
    "gensim": "3.8.0",
    "joblib": "0.13.2",
    "scipy": "1.4.1",
    "pyphen": "0.9.5",
    'rsa': '4.0',
    'msgpack-python': '1.0.0'
}

@conda_base(libraries=deps)
class GoraniFlowSpec(FlowSpec):
    config_file = IncludeFile(
        'config',
        is_text=False,
        help='Config Key File',
        default='./config.yaml')

from .generate_review import GenerateReview
from .download import Download
from .prepare_features import PrepareFeatures
from .generate_stats import GenerateStats
from .predict_vocab import PredictVocab
from .preprocess_paginate import PreprocessPaginate

__all__ = [
    "GenerateReview",
    "Download",
    "GenerateStats",
    "PrepareFeatures",
    "PredictVocab",
    "PreprocessPaginate"
]