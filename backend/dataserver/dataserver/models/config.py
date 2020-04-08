from typing import NamedTuple

class Config(NamedTuple):
    cluster_threshold: float
    max_session_hours: float
    filter_wpm_threshold: float
    cheat_eltime_threshold: float
    notify_topic_arn: str