from typing import NamedTuple, List, Dict

from dataserver.booky import Book
from dataserver.commonmodels.eventlog import EventLog


class RawData(NamedTuple):
    """
    생 데이터입니다.
    """
    logs: List[EventLog]
    users: Dict[str, dict]
    books: Dict[str, Book]