import pandera as pa

ParsedPagesDataFrame = pa.DataFrameSchema({
    "time": pa.Column(pa.Int),
    "userId": pa.Column(pa.String),
    "eltime": pa.Column(),
    "from": pa.Column(pa.String),
    "rcId": pa.Column(pa.String),
    "sids": pa.Column(pa.Object),
    "pos": pa.Column(pa.Object),
    "words": pa.Column(pa.Object),
    "unknownWords": pa.Column(pa.Object),
    "unknownIndices": pa.Column(pa.Object)
}, strict=True)

SignalDataFrame = pa.DataFrameSchema({
    "pageId": pa.Column(pa.Int),
    "word": pa.Column(pa.String),
    "signal": pa.Column(pa.Float),
    "userId": pa.Column(pa.String),
    "session": pa.Column(pa.Int),
    "cheat": pa.Column(pa.Bool),
    'wpm':  pa.Column(pa.Float),
    "pos": pa.Column(pa.String),
    "time": pa.Column(pa.Int),
}, strict=True)

CleanPagesDataFrame = pa.DataFrameSchema({
    "pageId": pa.Column(pa.Int),
    "time": pa.Column(pa.Int),
    "userId": pa.Column(pa.String),
    "eltime": pa.Column(pa.Float),
    "wpm": pa.Column(pa.Float),
    "from": pa.Column(pa.String),
    "rcId": pa.Column(pa.String),
    "itemsJson": pa.Column(pa.String),
    "words": pa.Column(pa.Object),
    "knownWords": pa.Column(pa.Object),
    "unknownWords": pa.Column(pa.Object),
    "session": pa.Column(pa.Int),
    "cheat": pa.Column(pa.Bool),
}, strict=True)

SessionInfoDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "session": pa.Column(pa.Int),
    "start": pa.Column(pa.Int),
    "end": pa.Column(pa.Int),
    "wpm": pa.Column(pa.Float),
    "readWords": pa.Column(pa.Int),
    "unknownWords": pa.Column(pa.Int),
    "hours": pa.Column(pa.Float),
}, strict=True)

LastSessionDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "session": pa.Column(pa.Int),
    "end": pa.Column(pa.Int)
}, strict=True)

LastWordsDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "session": pa.Column(pa.Int),
    "lastWords": pa.Column(pa.String),
    "targetLastWords": pa.Column(pa.Int)
}, strict=True)

StatsDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "stats": pa.Column(pa.String)
}, strict=True)

ReviewDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "review": pa.Column(pa.String)
}, strict=True)