from typing import NamedTuple

class Config(NamedTuple):
    cluster_threshold: float
    max_session_hours: float
    filter_wpm_threshold: float
    cheat_eltime_threshold: float
    notify_topic_arn: str
    firebase_project_id: str
    firebase_cert: dict
    word2vec_k: int

    client_event_logs_s3_bucket: str
    generated_review_s3_bucket: str
    vocab_skills_s3_bucket: str

    last_session_after_hours: float
    skip_session_hours: float