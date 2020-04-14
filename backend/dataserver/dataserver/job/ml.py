from io import BytesIO

from dataserver.job.prepare_features import split_simple_features
from dataserver.models.model import Model, ModelType
from datetime import datetime
import time

def train_simple_rf(x_train, y_train, feature_type: str, last_feature_time: float):
    import joblib
    import xgboost as xgb
    bytes_container = BytesIO()
    model = xgb.XGBClassifier(n_estimators=100, max_depth=7)
    model.fit(x_train, y_train)
    joblib.dump(model, bytes_container)
    bytes_container.seek(0)
    return Model(time.time(), "simple_rf", feature_type, last_feature_time, ModelType.XGBOOST, bytes_container.read())

def predict_vocab( features, signals_df, model, nlp_service):
    classifier = model.get_classifier()

    x, z, meta_df = split_simple_features(features)
    y = classifier.predict(x)
    df = meta_df[['otime', 'userId', 'word', 'oword', 'pageId']]
    unknown_words_df = df.iloc[y == 1]

    signals = signals_df.copy()
    signals['oword'] = signals['word']
    signals['word'] = signals['word'].map(nlp_service.stem)
    signals['maxTime'] = signals.groupby(['userId', 'word'])['time'].transform(max)
    signals = signals.loc[signals['time'] == signals['maxTime']]
    signals = signals.drop_duplicates(['userId', 'word'])
    signals = signals.set_index(['userId', 'word'])
    unknown_words_df = unknown_words_df.set_index(['userId', 'word'])

    outer_join = signals.merge(unknown_words_df, left_index=True, right_index=True, how='outer', indicator=True)


    known_words_df = outer_join[~(outer_join._merge == 'both')].drop('_merge', axis=1)
    known_words_df['oword'] = known_words_df['oword_x']
    known_words_df['pageId'] = known_words_df['pageId_x']
    unknown_words_df['time'] = unknown_words_df['otime']

    unknown_words_df = unknown_words_df.reset_index()[['word', 'oword', 'pageId', 'userId', 'time']]
    known_words_df = known_words_df.reset_index()[['word', 'oword', 'pageId', 'userId', 'time']]
    return known_words_df, unknown_words_df
