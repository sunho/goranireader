from typing import NamedTuple

class Config(NamedTuple):
    # parameters
    cluster_threshold: float
    max_session_hours: float
    filter_wpm_threshold: float
    cheat_eltime_threshold: float

    last_session_after_hours: float
    skip_session_hours: float

    word2vec_k: int

    # s3
    s3_endpoint: str
    s3_key: str
    s3_secret: str
    s3_region: str

    client_event_logs_s3_bucket: str
    generated_review_s3_bucket: str
    vocab_skills_s3_bucket: str

