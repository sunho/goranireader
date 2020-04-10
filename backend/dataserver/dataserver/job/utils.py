import functools
import time

from datetime import timedelta, tzinfo, datetime
from dateutil.parser import parse

import numpy as np
import calendar

from pytz import timezone, utc
import pandas as pd

def parse_ts_from_iso(s):
    return calendar.timegm(parse(str(s)).utctimetuple())

def parse_kst_date_from_ts(ts):
    kst = timezone('Asia/Seoul')
    date = utc.localize(datetime.utcfromtimestamp(ts))
    return date.astimezone(kst)

def unnesting(df, explode):
    idx = df.index.repeat(df[explode[0]].str.len())
    df1 = pd.concat([
        pd.DataFrame({x: np.concatenate(df[x].values)}) for x in explode], axis=1)
    df1.index = idx

    return df1.join(df.drop(explode, 1), how='left').reset_index(drop=True)