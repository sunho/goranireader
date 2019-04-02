from .to_sentence_time import TransformToSentenceTime
from .to_known_words import TransformToKnownWordsJob
from gorani.shared import StreamJobContext, PartialStreamJob
from typing import List

def factory(context: StreamJobContext) -> List[PartialStreamJob]:
    return [
        TransformToSentenceTime(context) + TransformToKnownWordsJob(context)
    ]
