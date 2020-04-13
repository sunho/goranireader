from typing import NamedTuple
from typing import List

class VocabSkill(NamedTuple):
    name: str
    importance: float
    words: List[str]