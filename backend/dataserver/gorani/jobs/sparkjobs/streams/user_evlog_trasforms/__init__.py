from .to_sentence_time import TransformToSentenceTime
from gorani.shared import StreamJobContext, PartialStreamJob
from typing import List

def factory(context: StreamJobContext) -> List[PartialStreamJob]:
    return [
        TransformToSentenceTime(context)
    ]
