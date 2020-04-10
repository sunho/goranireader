import pytest

import pandas as pd
from dataserver.job.utils import parse_ts_from_iso, parse_kst_date_from_ts, unnesting

def test_times():
    iso_str = "2020-04-09T17:18:46+0900"
    ts = parse_ts_from_iso(iso_str)
    assert ts == 1586420326

    ts = 1586420326
    date = parse_kst_date_from_ts(ts)
    assert date.strftime("%Y %m %d %H:%M:%S") == "2020 04 09 17:18:46"

    iso_str = "2020-04-09T08:18:46Z"
    ts = parse_ts_from_iso(iso_str)
    assert ts == 1586420326

    ts = 1586420326
    date = parse_kst_date_from_ts(ts)
    assert date.strftime("%Y %m %d %H:%M:%S") == "2020 04 09 17:18:46"

def test_unnesting():
    df = pd.DataFrame([
        {
            "hi": ["a","b","c"],
            "ho": ["ho", "ho", "ho"]
        }
    ])
    df = unnesting(df, ["hi", "ho"])
    df2 = pd.DataFrame([
        {
            "hi": "a",
            "ho": "ho"
        },
        {
            "hi": "b",
            "ho": "ho"
        },
        {
            "hi": "c",
            "ho": "ho"
        }
    ])
    pd.testing.assert_frame_equal(df, df2)
