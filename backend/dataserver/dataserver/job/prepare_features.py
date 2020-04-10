import pandas as pd

def prepare_simple_features(signals_df):
    df = signals_df.sort_values(['time'])
    df['diff'] = df.groupby(['userId', 'word'])['time'].diff().fillna(0)
    df['diff'] /= (60*60*24)
    df['time_min'] = df.groupby(['userId', 'word'])['time'].transform(min)
    df['time'] = df['time'] - df['time_min']
    df['csignal'] = df.groupby(['userId', 'word'])['signal'] \
        .apply(lambda x: x.expanding().mean().shift())
    df = df.loc[df['diff'] >= 0.1]
    df['count'] = df.groupby(['userId', 'word'])\
        .cumcount().add(1)
    df['ccount'] = df.groupby(['userId', 'word'])['count'].transform(max)
    df = df.loc[df['ccount'] <= 15]
    return df[['userId', 'word', 'time', 'count', 'signal', 'csignal', 'diff']]

