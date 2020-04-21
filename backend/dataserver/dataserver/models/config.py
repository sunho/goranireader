from typing import NamedTuple

class Config(NamedTuple):
    cluster_threshold: float
    max_session_hours: float
    filter_wpm_threshold: float
    cheat_eltime_threshold: float

    last_session_after_hours: float
    skip_session_hours: float

    word2vec_k: int