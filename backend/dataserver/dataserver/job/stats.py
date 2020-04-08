
def extract_session_info_df(signals_df, clean_pages_df):
    signals_df = signals_df.copy()
    df = signals_df.groupby(['userId', 'session']) \
        .agg(start=('time', 'min'),
             end=('time', 'max'),
             nwords=('signal', 'sum'),
             readWords=('word', 'count'))
    df['unknownWords'] = (df['readWords'] - df['nwords']).astype('int64')
    del df['nwords']

    clean_pages_df = clean_pages_df.copy()
    df2 = clean_pages_df.groupby(['userId', 'session']) \
        .agg(wpm=('wpm', 'mean'),
             eltime=('eltime', 'sum'))
    df2['hours'] = (df2['eltime']) / (60 * 60)
    del df2['eltime']

    df3 = df.join(df2).reset_index()
    return SessionInfoDataFrame.validate(df3)

def extract_session_info_df(signals_df, clean_pages_df):
    signals_df = signals_df.copy()
    df = signals_df.groupby(['userId', 'session']) \
        .agg(start=('time', 'min'),
             end=('time', 'max'),
             nwords=('signal', 'sum'),
             readWords=('word', 'count'))
    df['unknownWords'] = (df['readWords'] - df['nwords']).astype('int64')
    del df['nwords']

    clean_pages_df = clean_pages_df.copy()
    df2 = clean_pages_df.groupby(['userId', 'session']) \
        .agg(wpm=('wpm', 'mean'),
             eltime=('eltime', 'sum'))
    df2['hours'] = (df2['eltime']) / (60 * 60)
    del df2['eltime']

    df3 = df.join(df2).reset_index()
    return SessionInfoDataFrame.validate(df3)