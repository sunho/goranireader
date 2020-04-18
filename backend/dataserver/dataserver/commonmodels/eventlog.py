# To use this code, make sure you
#
#     import json
#
# and then, to convert JSON from a string, do
#
#     result = event_log_from_dict(json.loads(json_string))
#     result = event_log_payload_from_dict(json.loads(json_string))
#     result = log_paginate_payload_from_dict(json.loads(json_string))
#     result = paginate_word_unknown_from_dict(json.loads(json_string))
#     result = log_active_payload_from_dict(json.loads(json_string))
#     result = log_deactive_payload_from_dict(json.loads(json_string))
#     result = log_review_start_payload_from_dict(json.loads(json_string))
#     result = log_review_paginate_payload_from_dict(json.loads(json_string))
#     result = log_lw_review_next_payload_from_dict(json.loads(json_string))
#     result = log_lw_review_giveup_payload_from_dict(json.loads(json_string))
#     result = log_lw_review_complete_payload_from_dict(json.loads(json_string))
#     result = log_review_end_payload_from_dict(json.loads(json_string))
#     result = step_from_dict(json.loads(json_string))

from enum import Enum
from typing import Any, Optional, List, TypeVar, Callable, Type, cast


T = TypeVar("T")
EnumT = TypeVar("EnumT", bound=Enum)


def from_str(x: Any) -> str:
    assert isinstance(x, str)
    return x


def from_float(x: Any) -> float:
    assert isinstance(x, (float, int)) and not isinstance(x, bool)
    return float(x)


def to_float(x: Any) -> float:
    assert isinstance(x, float)
    return x


def from_none(x: Any) -> Any:
    assert x is None
    return x


def from_union(fs, x):
    for f in fs:
        try:
            return f(x)
        except:
            pass
    assert False


def from_list(f: Callable[[Any], T], x: Any) -> List[T]:
    assert isinstance(x, list)
    return [f(y) for y in x]


def to_enum(c: Type[EnumT], x: Any) -> EnumT:
    assert isinstance(x, c)
    return x.value


def to_class(c: Type[T], x: Any) -> dict:
    assert isinstance(x, c)
    return cast(Any, x).to_dict()


class Step(Enum):
    """리뷰 게임의 단계를 나타냅니다"""
    REVIEW_WORDS = "review-words"


class PayloadType(Enum):
    ACTIVE = "active"
    DEACTIVE = "deactive"
    PAGINATE = "paginate"
    REVIEW_END = "review-end"
    REVIEW_PAGINATE = "review-paginate"
    REVIEW_START = "review-start"
    REVIEW_WORDS_REVIEW_COMPLETE = "review-words-review-complete"
    REVIEW_WORDS_REVIEW_GIVEUP = "review-words-review-giveup"
    REVIEW_WORDS_REVIEW_NEXT = "review-words-review-next"


class PaginateWordUnknown:
    """찾아봤던 단어에 대한 정보를 담고 있습니다."""
    sentence_id: str
    """페이지 시작후로부터 경과한 시간입니다. 단위는 ms입니다."""
    time: float
    word: str
    """해당 문장을 아래 정규식을 기준으로 split했을 때 찾아본 단어가 몇번째인지 나타냅니다.
    ```
    * /([^a-zA-Z-']+)/
    * ```
    """
    word_index: float

    def __init__(self, sentence_id: str, time: float, word: str, word_index: float) -> None:
        self.sentence_id = sentence_id
        self.time = time
        self.word = word
        self.word_index = word_index

    @staticmethod
    def from_dict(obj: Any) -> 'PaginateWordUnknown':
        assert isinstance(obj, dict)
        sentence_id = from_str(obj.get("sentenceId"))
        time = from_float(obj.get("time"))
        word = from_str(obj.get("word"))
        word_index = from_float(obj.get("wordIndex"))
        return PaginateWordUnknown(sentence_id, time, word, word_index)

    def to_dict(self) -> dict:
        result: dict = {}
        result["sentenceId"] = from_str(self.sentence_id)
        result["time"] = to_float(self.time)
        result["word"] = from_str(self.word)
        result["wordIndex"] = to_float(self.word_index)
        return result


class EventLogPayload:
    """이벤트 로그의 실질적인 정보를 담고 있습니다.
    
    사용자가 페이지를 앞이나 뒤로 넘겼을 때 전송됩니다.
    
    사용자가 리뷰게임을 시작했을 때 전송됩니다.
    
    사용자가 리뷰게임의 리더에서 페이지를 넘겼을 때 전송됩니다.
    
    사용자가 리뷰게임에서 페이지의 단어들을 다 리뷰하고 다음으로 넘어갈 때 전송됩니다.
    
    사용자가 리뷰게임을 포기했을 때 발생합니다.
    
    사용자가 리뷰게임의 목표 복습 단어수 이상의 단어를 복습하고 완료 버튼을 눌렀을 때 발생합니다.
    
    사용자가 리뷰게임을 종료했을 때 발생합니다.
    
    사용자가 특정 페이지에 들어왔을 때 전송됩니다.
    
    사용자가 특정 페이지에서 나갔을 때 전송됩니다.
    """
    book_id: Optional[str]
    chapter_id: Optional[str]
    """본문에 있는 문장들의 배열입니다."""
    content: Optional[List[str]]
    """해당 페이지에 있엇던 문장들의 아이디입니다."""
    sentence_ids: Optional[List[str]]
    """해당 페이지를 넘기기까지 걸린 시간입니다. 단위는 ms입니다.
    
    페이지가 나타나고부터 경과한 시간
    
    리뷰게임을 시작하고부터 경과한 시간.
    """
    time: Optional[float]
    type: PayloadType
    """해당 페이지를 보면서 찾아봤던 단어에 대한 정보를 담고 있습니다."""
    word_unknowns: Optional[List[PaginateWordUnknown]]
    review_id: Optional[str]
    """리뷰 게임의 단계를 나타냅니다"""
    step: Optional[Step]
    """해당 텍스트에서 습득해야할 목표 단어입니다."""
    target_words: Optional[List[str]]
    """전까지 복습한 단어의 수"""
    previous_completed_words: Optional[float]
    """사용자가 선택한 단어들입니다."""
    selected_words: Optional[List[str]]
    """목표 복습 단어 수"""
    target_completed_words: Optional[float]
    """사용자가 선택할 수 있엇던 단어들입니다."""
    visible_words: Optional[List[str]]
    """해당 리뷰게임에 포함된 목표 단어들입니다.
    
    목표 습득 단어들
    """
    words: Optional[List[str]]
    """복습한 단어의 수"""
    completed_words: Optional[float]
    page: Optional[str]

    def __init__(self, book_id: Optional[str], chapter_id: Optional[str], content: Optional[List[str]], sentence_ids: Optional[List[str]], time: Optional[float], type: PayloadType, word_unknowns: Optional[List[PaginateWordUnknown]], review_id: Optional[str], step: Optional[Step], target_words: Optional[List[str]], previous_completed_words: Optional[float], selected_words: Optional[List[str]], target_completed_words: Optional[float], visible_words: Optional[List[str]], words: Optional[List[str]], completed_words: Optional[float], page: Optional[str]) -> None:
        self.book_id = book_id
        self.chapter_id = chapter_id
        self.content = content
        self.sentence_ids = sentence_ids
        self.time = time
        self.type = type
        self.word_unknowns = word_unknowns
        self.review_id = review_id
        self.step = step
        self.target_words = target_words
        self.previous_completed_words = previous_completed_words
        self.selected_words = selected_words
        self.target_completed_words = target_completed_words
        self.visible_words = visible_words
        self.words = words
        self.completed_words = completed_words
        self.page = page

    @staticmethod
    def from_dict(obj: Any) -> 'EventLogPayload':
        assert isinstance(obj, dict)
        book_id = from_union([from_str, from_none], obj.get("bookId"))
        chapter_id = from_union([from_str, from_none], obj.get("chapterId"))
        content = from_union([lambda x: from_list(from_str, x), from_none], obj.get("content"))
        sentence_ids = from_union([lambda x: from_list(from_str, x), from_none], obj.get("sentenceIds"))
        time = from_union([from_float, from_none], obj.get("time"))
        type = PayloadType(obj.get("type"))
        word_unknowns = from_union([lambda x: from_list(PaginateWordUnknown.from_dict, x), from_none], obj.get("wordUnknowns"))
        review_id = from_union([from_str, from_none], obj.get("reviewId"))
        step = from_union([Step, from_none], obj.get("step"))
        target_words = from_union([lambda x: from_list(from_str, x), from_none], obj.get("targetWords"))
        previous_completed_words = from_union([from_float, from_none], obj.get("previousCompletedWords"))
        selected_words = from_union([lambda x: from_list(from_str, x), from_none], obj.get("selectedWords"))
        target_completed_words = from_union([from_float, from_none], obj.get("targetCompletedWords"))
        visible_words = from_union([lambda x: from_list(from_str, x), from_none], obj.get("visibleWords"))
        words = from_union([lambda x: from_list(from_str, x), from_none], obj.get("words"))
        completed_words = from_union([from_float, from_none], obj.get("completedWords"))
        page = from_union([from_str, from_none], obj.get("page"))
        return EventLogPayload(book_id, chapter_id, content, sentence_ids, time, type, word_unknowns, review_id, step, target_words, previous_completed_words, selected_words, target_completed_words, visible_words, words, completed_words, page)

    def to_dict(self) -> dict:
        result: dict = {}
        result["bookId"] = from_union([from_str, from_none], self.book_id)
        result["chapterId"] = from_union([from_str, from_none], self.chapter_id)
        result["content"] = from_union([lambda x: from_list(from_str, x), from_none], self.content)
        result["sentenceIds"] = from_union([lambda x: from_list(from_str, x), from_none], self.sentence_ids)
        result["time"] = from_union([to_float, from_none], self.time)
        result["type"] = to_enum(PayloadType, self.type)
        result["wordUnknowns"] = from_union([lambda x: from_list(lambda x: to_class(PaginateWordUnknown, x), x), from_none], self.word_unknowns)
        result["reviewId"] = from_union([from_str, from_none], self.review_id)
        result["step"] = from_union([lambda x: to_enum(Step, x), from_none], self.step)
        result["targetWords"] = from_union([lambda x: from_list(from_str, x), from_none], self.target_words)
        result["previousCompletedWords"] = from_union([to_float, from_none], self.previous_completed_words)
        result["selectedWords"] = from_union([lambda x: from_list(from_str, x), from_none], self.selected_words)
        result["targetCompletedWords"] = from_union([to_float, from_none], self.target_completed_words)
        result["visibleWords"] = from_union([lambda x: from_list(from_str, x), from_none], self.visible_words)
        result["words"] = from_union([lambda x: from_list(from_str, x), from_none], self.words)
        result["completedWords"] = from_union([to_float, from_none], self.completed_words)
        result["page"] = from_union([from_str, from_none], self.page)
        return result


class EventLog:
    """이벤트 로그를 나타냅니다."""
    """이벤트 로그의 실질적인 정보를 담고 있습니다."""
    payload: EventLogPayload
    """로그가 작성된 시각입니다. rfc3339형태 입니다."""
    time: str
    """uuid형태 입니다."""
    user_id: str

    def __init__(self, payload: EventLogPayload, time: str, user_id: str) -> None:
        self.payload = payload
        self.time = time
        self.user_id = user_id

    @staticmethod
    def from_dict(obj: Any) -> 'EventLog':
        assert isinstance(obj, dict)
        payload = EventLogPayload.from_dict(obj.get("payload"))
        time = from_str(obj.get("time"))
        user_id = from_str(obj.get("userId"))
        return EventLog(payload, time, user_id)

    def to_dict(self) -> dict:
        result: dict = {}
        result["payload"] = to_class(EventLogPayload, self.payload)
        result["time"] = from_str(self.time)
        result["userId"] = from_str(self.user_id)
        return result


class LogPaginatePayloadType(Enum):
    PAGINATE = "paginate"


class LogPaginatePayload:
    """사용자가 페이지를 앞이나 뒤로 넘겼을 때 전송됩니다."""
    book_id: str
    chapter_id: str
    """본문에 있는 문장들의 배열입니다."""
    content: List[str]
    """해당 페이지에 있엇던 문장들의 아이디입니다."""
    sentence_ids: List[str]
    """해당 페이지를 넘기기까지 걸린 시간입니다. 단위는 ms입니다."""
    time: float
    type: LogPaginatePayloadType
    """해당 페이지를 보면서 찾아봤던 단어에 대한 정보를 담고 있습니다."""
    word_unknowns: List[PaginateWordUnknown]

    def __init__(self, book_id: str, chapter_id: str, content: List[str], sentence_ids: List[str], time: float, type: LogPaginatePayloadType, word_unknowns: List[PaginateWordUnknown]) -> None:
        self.book_id = book_id
        self.chapter_id = chapter_id
        self.content = content
        self.sentence_ids = sentence_ids
        self.time = time
        self.type = type
        self.word_unknowns = word_unknowns

    @staticmethod
    def from_dict(obj: Any) -> 'LogPaginatePayload':
        assert isinstance(obj, dict)
        book_id = from_str(obj.get("bookId"))
        chapter_id = from_str(obj.get("chapterId"))
        content = from_list(from_str, obj.get("content"))
        sentence_ids = from_list(from_str, obj.get("sentenceIds"))
        time = from_float(obj.get("time"))
        type = LogPaginatePayloadType(obj.get("type"))
        word_unknowns = from_list(PaginateWordUnknown.from_dict, obj.get("wordUnknowns"))
        return LogPaginatePayload(book_id, chapter_id, content, sentence_ids, time, type, word_unknowns)

    def to_dict(self) -> dict:
        result: dict = {}
        result["bookId"] = from_str(self.book_id)
        result["chapterId"] = from_str(self.chapter_id)
        result["content"] = from_list(from_str, self.content)
        result["sentenceIds"] = from_list(from_str, self.sentence_ids)
        result["time"] = to_float(self.time)
        result["type"] = to_enum(LogPaginatePayloadType, self.type)
        result["wordUnknowns"] = from_list(lambda x: to_class(PaginateWordUnknown, x), self.word_unknowns)
        return result


class LogActivePayloadType(Enum):
    ACTIVE = "active"


class LogActivePayload:
    """사용자가 특정 페이지에 들어왔을 때 전송됩니다."""
    page: str
    type: LogActivePayloadType

    def __init__(self, page: str, type: LogActivePayloadType) -> None:
        self.page = page
        self.type = type

    @staticmethod
    def from_dict(obj: Any) -> 'LogActivePayload':
        assert isinstance(obj, dict)
        page = from_str(obj.get("page"))
        type = LogActivePayloadType(obj.get("type"))
        return LogActivePayload(page, type)

    def to_dict(self) -> dict:
        result: dict = {}
        result["page"] = from_str(self.page)
        result["type"] = to_enum(LogActivePayloadType, self.type)
        return result


class LogDeactivePayloadType(Enum):
    DEACTIVE = "deactive"


class LogDeactivePayload:
    """사용자가 특정 페이지에서 나갔을 때 전송됩니다."""
    page: str
    type: LogDeactivePayloadType

    def __init__(self, page: str, type: LogDeactivePayloadType) -> None:
        self.page = page
        self.type = type

    @staticmethod
    def from_dict(obj: Any) -> 'LogDeactivePayload':
        assert isinstance(obj, dict)
        page = from_str(obj.get("page"))
        type = LogDeactivePayloadType(obj.get("type"))
        return LogDeactivePayload(page, type)

    def to_dict(self) -> dict:
        result: dict = {}
        result["page"] = from_str(self.page)
        result["type"] = to_enum(LogDeactivePayloadType, self.type)
        return result


class LogReviewStartPayloadType(Enum):
    REVIEW_START = "review-start"


class LogReviewStartPayload:
    """사용자가 리뷰게임을 시작했을 때 전송됩니다."""
    review_id: str
    """리뷰 게임의 단계를 나타냅니다"""
    step: Step
    type: LogReviewStartPayloadType

    def __init__(self, review_id: str, step: Step, type: LogReviewStartPayloadType) -> None:
        self.review_id = review_id
        self.step = step
        self.type = type

    @staticmethod
    def from_dict(obj: Any) -> 'LogReviewStartPayload':
        assert isinstance(obj, dict)
        review_id = from_str(obj.get("reviewId"))
        step = Step(obj.get("step"))
        type = LogReviewStartPayloadType(obj.get("type"))
        return LogReviewStartPayload(review_id, step, type)

    def to_dict(self) -> dict:
        result: dict = {}
        result["reviewId"] = from_str(self.review_id)
        result["step"] = to_enum(Step, self.step)
        result["type"] = to_enum(LogReviewStartPayloadType, self.type)
        return result


class LogReviewPaginatePayloadType(Enum):
    REVIEW_PAGINATE = "review-paginate"


class LogReviewPaginatePayload:
    """사용자가 리뷰게임의 리더에서 페이지를 넘겼을 때 전송됩니다."""
    """본문에 있는 문장들의 배열입니다."""
    content: List[str]
    review_id: str
    sentence_ids: List[str]
    """리뷰 게임의 단계를 나타냅니다"""
    step: Step
    """해당 텍스트에서 습득해야할 목표 단어입니다."""
    target_words: List[str]
    """해당 페이지를 넘기기까지 걸린 시간입니다. 단위는 ms입니다."""
    time: float
    type: LogReviewPaginatePayloadType
    """해당 페이지를 보면서 찾아봤던 단어에 대한 정보를 담고 있습니다."""
    word_unknowns: List[PaginateWordUnknown]

    def __init__(self, content: List[str], review_id: str, sentence_ids: List[str], step: Step, target_words: List[str], time: float, type: LogReviewPaginatePayloadType, word_unknowns: List[PaginateWordUnknown]) -> None:
        self.content = content
        self.review_id = review_id
        self.sentence_ids = sentence_ids
        self.step = step
        self.target_words = target_words
        self.time = time
        self.type = type
        self.word_unknowns = word_unknowns

    @staticmethod
    def from_dict(obj: Any) -> 'LogReviewPaginatePayload':
        assert isinstance(obj, dict)
        content = from_list(from_str, obj.get("content"))
        review_id = from_str(obj.get("reviewId"))
        sentence_ids = from_list(from_str, obj.get("sentenceIds"))
        step = Step(obj.get("step"))
        target_words = from_list(from_str, obj.get("targetWords"))
        time = from_float(obj.get("time"))
        type = LogReviewPaginatePayloadType(obj.get("type"))
        word_unknowns = from_list(PaginateWordUnknown.from_dict, obj.get("wordUnknowns"))
        return LogReviewPaginatePayload(content, review_id, sentence_ids, step, target_words, time, type, word_unknowns)

    def to_dict(self) -> dict:
        result: dict = {}
        result["content"] = from_list(from_str, self.content)
        result["reviewId"] = from_str(self.review_id)
        result["sentenceIds"] = from_list(from_str, self.sentence_ids)
        result["step"] = to_enum(Step, self.step)
        result["targetWords"] = from_list(from_str, self.target_words)
        result["time"] = to_float(self.time)
        result["type"] = to_enum(LogReviewPaginatePayloadType, self.type)
        result["wordUnknowns"] = from_list(lambda x: to_class(PaginateWordUnknown, x), self.word_unknowns)
        return result


class LogLWReviewNextPayloadType(Enum):
    REVIEW_WORDS_REVIEW_NEXT = "review-words-review-next"


class LogLWReviewNextPayload:
    """사용자가 리뷰게임에서 페이지의 단어들을 다 리뷰하고 다음으로 넘어갈 때 전송됩니다."""
    """전까지 복습한 단어의 수"""
    previous_completed_words: float
    review_id: str
    """사용자가 선택한 단어들입니다."""
    selected_words: List[str]
    """목표 복습 단어 수"""
    target_completed_words: float
    """페이지가 나타나고부터 경과한 시간"""
    time: float
    type: LogLWReviewNextPayloadType
    """사용자가 선택할 수 있엇던 단어들입니다."""
    visible_words: List[str]
    """해당 리뷰게임에 포함된 목표 단어들입니다."""
    words: List[str]

    def __init__(self, previous_completed_words: float, review_id: str, selected_words: List[str], target_completed_words: float, time: float, type: LogLWReviewNextPayloadType, visible_words: List[str], words: List[str]) -> None:
        self.previous_completed_words = previous_completed_words
        self.review_id = review_id
        self.selected_words = selected_words
        self.target_completed_words = target_completed_words
        self.time = time
        self.type = type
        self.visible_words = visible_words
        self.words = words

    @staticmethod
    def from_dict(obj: Any) -> 'LogLWReviewNextPayload':
        assert isinstance(obj, dict)
        previous_completed_words = from_float(obj.get("previousCompletedWords"))
        review_id = from_str(obj.get("reviewId"))
        selected_words = from_list(from_str, obj.get("selectedWords"))
        target_completed_words = from_float(obj.get("targetCompletedWords"))
        time = from_float(obj.get("time"))
        type = LogLWReviewNextPayloadType(obj.get("type"))
        visible_words = from_list(from_str, obj.get("visibleWords"))
        words = from_list(from_str, obj.get("words"))
        return LogLWReviewNextPayload(previous_completed_words, review_id, selected_words, target_completed_words, time, type, visible_words, words)

    def to_dict(self) -> dict:
        result: dict = {}
        result["previousCompletedWords"] = to_float(self.previous_completed_words)
        result["reviewId"] = from_str(self.review_id)
        result["selectedWords"] = from_list(from_str, self.selected_words)
        result["targetCompletedWords"] = to_float(self.target_completed_words)
        result["time"] = to_float(self.time)
        result["type"] = to_enum(LogLWReviewNextPayloadType, self.type)
        result["visibleWords"] = from_list(from_str, self.visible_words)
        result["words"] = from_list(from_str, self.words)
        return result


class LogLWReviewGiveupPayloadType(Enum):
    REVIEW_WORDS_REVIEW_GIVEUP = "review-words-review-giveup"


class LogLWReviewGiveupPayload:
    """사용자가 리뷰게임을 포기했을 때 발생합니다."""
    """복습한 단어의 수"""
    completed_words: float
    review_id: str
    """목표 복습 단어 수"""
    target_completed_words: float
    """리뷰게임을 시작하고부터 경과한 시간."""
    time: float
    type: LogLWReviewGiveupPayloadType
    """목표 습득 단어들"""
    words: List[str]

    def __init__(self, completed_words: float, review_id: str, target_completed_words: float, time: float, type: LogLWReviewGiveupPayloadType, words: List[str]) -> None:
        self.completed_words = completed_words
        self.review_id = review_id
        self.target_completed_words = target_completed_words
        self.time = time
        self.type = type
        self.words = words

    @staticmethod
    def from_dict(obj: Any) -> 'LogLWReviewGiveupPayload':
        assert isinstance(obj, dict)
        completed_words = from_float(obj.get("completedWords"))
        review_id = from_str(obj.get("reviewId"))
        target_completed_words = from_float(obj.get("targetCompletedWords"))
        time = from_float(obj.get("time"))
        type = LogLWReviewGiveupPayloadType(obj.get("type"))
        words = from_list(from_str, obj.get("words"))
        return LogLWReviewGiveupPayload(completed_words, review_id, target_completed_words, time, type, words)

    def to_dict(self) -> dict:
        result: dict = {}
        result["completedWords"] = to_float(self.completed_words)
        result["reviewId"] = from_str(self.review_id)
        result["targetCompletedWords"] = to_float(self.target_completed_words)
        result["time"] = to_float(self.time)
        result["type"] = to_enum(LogLWReviewGiveupPayloadType, self.type)
        result["words"] = from_list(from_str, self.words)
        return result


class LogLWReviewCompletePayloadType(Enum):
    REVIEW_WORDS_REVIEW_COMPLETE = "review-words-review-complete"


class LogLWReviewCompletePayload:
    """사용자가 리뷰게임의 목표 복습 단어수 이상의 단어를 복습하고 완료 버튼을 눌렀을 때 발생합니다."""
    """복습한 단어의 수"""
    completed_words: float
    review_id: str
    """목표 복습 단어 수"""
    target_completed_words: float
    """리뷰게임을 시작하고부터 경과한 시간."""
    time: float
    type: LogLWReviewCompletePayloadType
    """목표 습득 단어들"""
    words: List[str]

    def __init__(self, completed_words: float, review_id: str, target_completed_words: float, time: float, type: LogLWReviewCompletePayloadType, words: List[str]) -> None:
        self.completed_words = completed_words
        self.review_id = review_id
        self.target_completed_words = target_completed_words
        self.time = time
        self.type = type
        self.words = words

    @staticmethod
    def from_dict(obj: Any) -> 'LogLWReviewCompletePayload':
        assert isinstance(obj, dict)
        completed_words = from_float(obj.get("completedWords"))
        review_id = from_str(obj.get("reviewId"))
        target_completed_words = from_float(obj.get("targetCompletedWords"))
        time = from_float(obj.get("time"))
        type = LogLWReviewCompletePayloadType(obj.get("type"))
        words = from_list(from_str, obj.get("words"))
        return LogLWReviewCompletePayload(completed_words, review_id, target_completed_words, time, type, words)

    def to_dict(self) -> dict:
        result: dict = {}
        result["completedWords"] = to_float(self.completed_words)
        result["reviewId"] = from_str(self.review_id)
        result["targetCompletedWords"] = to_float(self.target_completed_words)
        result["time"] = to_float(self.time)
        result["type"] = to_enum(LogLWReviewCompletePayloadType, self.type)
        result["words"] = from_list(from_str, self.words)
        return result


class LogReviewEndPayloadType(Enum):
    REVIEW_END = "review-end"


class LogReviewEndPayload:
    """사용자가 리뷰게임을 종료했을 때 발생합니다."""
    review_id: str
    type: LogReviewEndPayloadType

    def __init__(self, review_id: str, type: LogReviewEndPayloadType) -> None:
        self.review_id = review_id
        self.type = type

    @staticmethod
    def from_dict(obj: Any) -> 'LogReviewEndPayload':
        assert isinstance(obj, dict)
        review_id = from_str(obj.get("reviewId"))
        type = LogReviewEndPayloadType(obj.get("type"))
        return LogReviewEndPayload(review_id, type)

    def to_dict(self) -> dict:
        result: dict = {}
        result["reviewId"] = from_str(self.review_id)
        result["type"] = to_enum(LogReviewEndPayloadType, self.type)
        return result


def event_log_from_dict(s: Any) -> EventLog:
    return EventLog.from_dict(s)


def event_log_to_dict(x: EventLog) -> Any:
    return to_class(EventLog, x)


def event_log_payload_from_dict(s: Any) -> EventLogPayload:
    return EventLogPayload.from_dict(s)


def event_log_payload_to_dict(x: EventLogPayload) -> Any:
    return to_class(EventLogPayload, x)


def log_paginate_payload_from_dict(s: Any) -> LogPaginatePayload:
    return LogPaginatePayload.from_dict(s)


def log_paginate_payload_to_dict(x: LogPaginatePayload) -> Any:
    return to_class(LogPaginatePayload, x)


def paginate_word_unknown_from_dict(s: Any) -> PaginateWordUnknown:
    return PaginateWordUnknown.from_dict(s)


def paginate_word_unknown_to_dict(x: PaginateWordUnknown) -> Any:
    return to_class(PaginateWordUnknown, x)


def log_active_payload_from_dict(s: Any) -> LogActivePayload:
    return LogActivePayload.from_dict(s)


def log_active_payload_to_dict(x: LogActivePayload) -> Any:
    return to_class(LogActivePayload, x)


def log_deactive_payload_from_dict(s: Any) -> LogDeactivePayload:
    return LogDeactivePayload.from_dict(s)


def log_deactive_payload_to_dict(x: LogDeactivePayload) -> Any:
    return to_class(LogDeactivePayload, x)


def log_review_start_payload_from_dict(s: Any) -> LogReviewStartPayload:
    return LogReviewStartPayload.from_dict(s)


def log_review_start_payload_to_dict(x: LogReviewStartPayload) -> Any:
    return to_class(LogReviewStartPayload, x)


def log_review_paginate_payload_from_dict(s: Any) -> LogReviewPaginatePayload:
    return LogReviewPaginatePayload.from_dict(s)


def log_review_paginate_payload_to_dict(x: LogReviewPaginatePayload) -> Any:
    return to_class(LogReviewPaginatePayload, x)


def log_lw_review_next_payload_from_dict(s: Any) -> LogLWReviewNextPayload:
    return LogLWReviewNextPayload.from_dict(s)


def log_lw_review_next_payload_to_dict(x: LogLWReviewNextPayload) -> Any:
    return to_class(LogLWReviewNextPayload, x)


def log_lw_review_giveup_payload_from_dict(s: Any) -> LogLWReviewGiveupPayload:
    return LogLWReviewGiveupPayload.from_dict(s)


def log_lw_review_giveup_payload_to_dict(x: LogLWReviewGiveupPayload) -> Any:
    return to_class(LogLWReviewGiveupPayload, x)


def log_lw_review_complete_payload_from_dict(s: Any) -> LogLWReviewCompletePayload:
    return LogLWReviewCompletePayload.from_dict(s)


def log_lw_review_complete_payload_to_dict(x: LogLWReviewCompletePayload) -> Any:
    return to_class(LogLWReviewCompletePayload, x)


def log_review_end_payload_from_dict(s: Any) -> LogReviewEndPayload:
    return LogReviewEndPayload.from_dict(s)


def log_review_end_payload_to_dict(x: LogReviewEndPayload) -> Any:
    return to_class(LogReviewEndPayload, x)


def step_from_dict(s: Any) -> Step:
    return Step(s)


def step_to_dict(x: Step) -> Any:
    return to_enum(Step, x)
