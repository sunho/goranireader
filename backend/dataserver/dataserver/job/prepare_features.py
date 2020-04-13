import pandas as pd

def prepare_simple_features(signals_df, nlp_service):
    signals_df = signals_df.copy()
    df = signals_df.sort_values(['time'])
    df['oword'] = df['word']
    df['word'] = df['word'].map(nlp_service.stem)
    df['diff'] = df.groupby(['userId', 'word'])['time'].diff().fillna(0)
    df['diff'] /= (60*60*24)
    df['time_min'] = df.groupby(['userId', 'word'])['time'].transform(min)
    df['otime'] = df['time']
    df['time'] = df['time'] - df['time_min']
    df['csignal'] = df.groupby(['userId', 'word'])['signal'] \
        .apply(lambda x: x.expanding().mean().shift())
    df['wpm'] = df.groupby(['userId', 'word'])['wpm'] \
        .apply(lambda x: x.expanding().mean().shift())
    df = df.loc[df['diff'] >= 0.1]
    df['count'] = df.groupby(['userId', 'word'])\
        .cumcount().add(1)
    df['ccount'] = df.groupby(['userId', 'word'])['count'].transform(max)
    df = df.loc[df['ccount'] <= 15]
    return df[['otime', 'userId', 'oword', 'word',  'time', 'count', 'signal', 'wpm', 'csignal', 'diff', 'pos']]\
        .reset_index(drop=True)


def prepare_series_features(signals_df):
    df = signals_df.copy().sort_values(['time'])
    df = df.drop_duplicates(['userId', 'word', 'time'])
    df['diff'] = (df.groupby(['userId', 'word'])['time'].diff() / (60 * 60 * 24)).fillna(5353)
    df = df.loc[df['diff'] >= 0.1]
    del df['diff']
    df['signal0'] = df.groupby(['userId', 'word'])['signal'] \
        .apply(lambda x: x.shift(2))
    df['signal1'] = df.groupby(['userId', 'word'])['signal'] \
        .apply(lambda x: x.shift())
    df['diff0'] = df.groupby(['userId', 'word'])['time']\
        .apply(lambda x: x.shift() - x.shift(2)) / (60*60*24)
    df['diff1'] = df.groupby(['userId', 'word'])['time'] \
        .apply(lambda x: x - x.shift()) / (60*60*24)
    df['time_min'] = df.groupby(['userId', 'word'])['time'].transform(min)
    df['time'] = df['time'] - df['time_min']
    df['wpm'] = df.groupby(['userId', 'word'])['wpm'] \
        .apply(lambda x: x.expanding().mean().shift())
    df = df.loc[~(pd.isna(df['diff0']) | pd.isna(df['diff1']))]
    df['count'] = df.groupby(['userId', 'word'])\
        .cumcount().add(1)
    return df[['userId', 'word', 'time', 'count', 'signal', 'wpm', 'signal0', 'diff0', 'signal1', 'diff1', 'pos']]\
        .reset_index(drop=True)

def annotate_simple_features(raw_df, vec_model, dic, k):
    import pandas as pd
    from sklearn.cluster import KMeans
    raw_df = raw_df.copy()
    words = raw_df['oword'].unique()
    vector_list = [vec_model[word] for word in words if word in vec_model.vocab]
    words_filtered = [word for word in words if word in vec_model.vocab]
    word_vec_zip = zip(words_filtered, vector_list)
    word_vec_dict = dict(word_vec_zip)
    df2 = pd.DataFrame.from_dict(word_vec_dict, orient='index')

    df = raw_df.copy().set_index('oword') \
        .join(df2[[]], how='right').reset_index().rename(columns={'index': 'oword'})
    df3 = raw_df[['oword']].copy().set_index('oword') \
        .join(df2, how='right').reset_index(drop=True)
    # TODO make seed configurable
    kmeans = KMeans(n_clusters=k, random_state=53).fit(df3)
    df = df.join(pd.get_dummies(kmeans.predict(df3)))

    data_df = df
    data_df['len'] = data_df['oword'].map(lambda x: len(str(x)))
    data_df['syl'] = data_df['oword'].map(lambda x: len(dic.inserted(str(x)).split('-')))
    return data_df.reset_index(drop=True)

def split_simple_features(df):
    meta_df = df.iloc[:, (df.columns == 'userId') | (df.columns == 'otime') | (df.columns == 'oword')
                              | (df.columns == 'word') | (df.columns == 'pos')]
    data_df = df.iloc[:, (df.columns != 'userId') & (df.columns != 'otime') & (df.columns != 'oword')
                              & (df.columns != 'word') & (df.columns != 'pos')]
    y = 1 - data_df['signal']
    x = data_df.iloc[:, data_df.columns != 'signal']
    return x.to_numpy(), y.to_numpy(), meta_df


def extract_recent_features(raw_df):
    raw_df = raw_df.copy()
    raw_df['count_max'] = raw_df.groupby(['userId', 'word'])['count'].transform(max)
    raw_df = raw_df.loc[raw_df['count'] == raw_df['count_max']]
    raw_df['csignal'] = (raw_df['signal'] + raw_df['csignal'] * raw_df['count']) / (raw_df['count'] + 1)
    raw_df['count'] = raw_df['count'] + 1
    del raw_df['count_max']
    return raw_df.reset_index(drop=True)

def get_last_input_time(meta_df):
    return meta_df['otime'].max()
