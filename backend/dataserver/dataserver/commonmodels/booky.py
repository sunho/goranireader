# To use this code, make sure you
#
#     import json
#
# and then, to convert JSON from a string, do
#
#     result = booky_book_from_dict(json.loads(json_string))
#     result = meta_from_dict(json.loads(json_string))
#     result = chapter_from_dict(json.loads(json_string))
#     result = item_from_dict(json.loads(json_string))
#     result = sentence_from_dict(json.loads(json_string))
#     result = image_from_dict(json.loads(json_string))

from enum import Enum
from typing import Optional, Any, List, TypeVar, Type, Callable, cast


T = TypeVar("T")
EnumT = TypeVar("EnumT", bound=Enum)


def from_str(x: Any) -> str:
    assert isinstance(x, str)
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


def from_bool(x: Any) -> bool:
    assert isinstance(x, bool)
    return x


def to_enum(c: Type[EnumT], x: Any) -> EnumT:
    assert isinstance(x, c)
    return x.value


def from_list(f: Callable[[Any], T], x: Any) -> List[T]:
    assert isinstance(x, list)
    return [f(y) for y in x]


def to_class(c: Type[T], x: Any) -> dict:
    assert isinstance(x, c)
    return cast(Any, x).to_dict()


class ItemKind(Enum):
    IMAGE = "image"
    SENTENCE = "sentence"


class Item:
    """문장을 나타냅니다.
    
    사진을 나타냅니다.
    """
    content: Optional[str]
    """uuid 형태 입니다."""
    id: str
    kind: ItemKind
    """true일 경우 이 문장을 시작하기 전에 줄바꿈을 해야합니다."""
    start: Optional[bool]
    """base64 형태 입니다."""
    image: Optional[str]
    """이미지의 mime-type입니다."""
    image_type: Optional[str]

    def __init__(self, content: Optional[str], id: str, kind: ItemKind, start: Optional[bool], image: Optional[str], image_type: Optional[str]) -> None:
        self.content = content
        self.id = id
        self.kind = kind
        self.start = start
        self.image = image
        self.image_type = image_type

    @staticmethod
    def from_dict(obj: Any) -> 'Item':
        assert isinstance(obj, dict)
        content = from_union([from_str, from_none], obj.get("content"))
        id = from_str(obj.get("id"))
        kind = ItemKind(obj.get("kind"))
        start = from_union([from_bool, from_none], obj.get("start"))
        image = from_union([from_str, from_none], obj.get("image"))
        image_type = from_union([from_str, from_none], obj.get("imageType"))
        return Item(content, id, kind, start, image, image_type)

    def to_dict(self) -> dict:
        result: dict = {}
        result["content"] = from_union([from_str, from_none], self.content)
        result["id"] = from_str(self.id)
        result["kind"] = to_enum(ItemKind, self.kind)
        result["start"] = from_union([from_bool, from_none], self.start)
        result["image"] = from_union([from_str, from_none], self.image)
        result["imageType"] = from_union([from_str, from_none], self.image_type)
        return result


class Chapter:
    """챕터를 나타내는 구조체 입니다."""
    """uuid 형태 입니다."""
    id: str
    """본문을 나타냅니다."""
    items: List[Item]
    title: str

    def __init__(self, id: str, items: List[Item], title: str) -> None:
        self.id = id
        self.items = items
        self.title = title

    @staticmethod
    def from_dict(obj: Any) -> 'Chapter':
        assert isinstance(obj, dict)
        id = from_str(obj.get("id"))
        items = from_list(Item.from_dict, obj.get("items"))
        title = from_str(obj.get("title"))
        return Chapter(id, items, title)

    def to_dict(self) -> dict:
        result: dict = {}
        result["id"] = from_str(self.id)
        result["items"] = from_list(lambda x: to_class(Item, x), self.items)
        result["title"] = from_str(self.title)
        return result


class Meta:
    """책에 대한 간략한 정보를 담고 있습니다."""
    author: str
    """base64 형태 입니다."""
    cover: str
    """표지 이미지의 mime-type입니다."""
    cover_type: str
    """uuid 형태 입니다."""
    id: str
    title: str

    def __init__(self, author: str, cover: str, cover_type: str, id: str, title: str) -> None:
        self.author = author
        self.cover = cover
        self.cover_type = cover_type
        self.id = id
        self.title = title

    @staticmethod
    def from_dict(obj: Any) -> 'Meta':
        assert isinstance(obj, dict)
        author = from_str(obj.get("author"))
        cover = from_str(obj.get("cover"))
        cover_type = from_str(obj.get("coverType"))
        id = from_str(obj.get("id"))
        title = from_str(obj.get("title"))
        return Meta(author, cover, cover_type, id, title)

    def to_dict(self) -> dict:
        result: dict = {}
        result["author"] = from_str(self.author)
        result["cover"] = from_str(self.cover)
        result["coverType"] = from_str(self.cover_type)
        result["id"] = from_str(self.id)
        result["title"] = from_str(self.title)
        return result


class BookyBook:
    """북키: 고라니 리더 독자 책 파일 포맷
    북키(고라니 리더 책 파일 포맷) 파일 하나를 표현하는 구조체입니다.
    """
    chapters: List[Chapter]
    meta: Meta

    def __init__(self, chapters: List[Chapter], meta: Meta) -> None:
        self.chapters = chapters
        self.meta = meta

    @staticmethod
    def from_dict(obj: Any) -> 'BookyBook':
        assert isinstance(obj, dict)
        chapters = from_list(Chapter.from_dict, obj.get("chapters"))
        meta = Meta.from_dict(obj.get("meta"))
        return BookyBook(chapters, meta)

    def to_dict(self) -> dict:
        result: dict = {}
        result["chapters"] = from_list(lambda x: to_class(Chapter, x), self.chapters)
        result["meta"] = to_class(Meta, self.meta)
        return result


class SentenceKind(Enum):
    SENTENCE = "sentence"


class Sentence:
    """문장을 나타냅니다."""
    content: str
    """uuid 형태 입니다."""
    id: str
    kind: SentenceKind
    """true일 경우 이 문장을 시작하기 전에 줄바꿈을 해야합니다."""
    start: bool

    def __init__(self, content: str, id: str, kind: SentenceKind, start: bool) -> None:
        self.content = content
        self.id = id
        self.kind = kind
        self.start = start

    @staticmethod
    def from_dict(obj: Any) -> 'Sentence':
        assert isinstance(obj, dict)
        content = from_str(obj.get("content"))
        id = from_str(obj.get("id"))
        kind = SentenceKind(obj.get("kind"))
        start = from_bool(obj.get("start"))
        return Sentence(content, id, kind, start)

    def to_dict(self) -> dict:
        result: dict = {}
        result["content"] = from_str(self.content)
        result["id"] = from_str(self.id)
        result["kind"] = to_enum(SentenceKind, self.kind)
        result["start"] = from_bool(self.start)
        return result


class ImageKind(Enum):
    IMAGE = "image"


class Image:
    """사진을 나타냅니다."""
    """uuid 형태 입니다."""
    id: str
    """base64 형태 입니다."""
    image: str
    """이미지의 mime-type입니다."""
    image_type: str
    kind: ImageKind

    def __init__(self, id: str, image: str, image_type: str, kind: ImageKind) -> None:
        self.id = id
        self.image = image
        self.image_type = image_type
        self.kind = kind

    @staticmethod
    def from_dict(obj: Any) -> 'Image':
        assert isinstance(obj, dict)
        id = from_str(obj.get("id"))
        image = from_str(obj.get("image"))
        image_type = from_str(obj.get("imageType"))
        kind = ImageKind(obj.get("kind"))
        return Image(id, image, image_type, kind)

    def to_dict(self) -> dict:
        result: dict = {}
        result["id"] = from_str(self.id)
        result["image"] = from_str(self.image)
        result["imageType"] = from_str(self.image_type)
        result["kind"] = to_enum(ImageKind, self.kind)
        return result


def booky_book_from_dict(s: Any) -> BookyBook:
    return BookyBook.from_dict(s)


def booky_book_to_dict(x: BookyBook) -> Any:
    return to_class(BookyBook, x)


def meta_from_dict(s: Any) -> Meta:
    return Meta.from_dict(s)


def meta_to_dict(x: Meta) -> Any:
    return to_class(Meta, x)


def chapter_from_dict(s: Any) -> Chapter:
    return Chapter.from_dict(s)


def chapter_to_dict(x: Chapter) -> Any:
    return to_class(Chapter, x)


def item_from_dict(s: Any) -> Item:
    return Item.from_dict(s)


def item_to_dict(x: Item) -> Any:
    return to_class(Item, x)


def sentence_from_dict(s: Any) -> Sentence:
    return Sentence.from_dict(s)


def sentence_to_dict(x: Sentence) -> Any:
    return to_class(Sentence, x)


def image_from_dict(s: Any) -> Image:
    return Image.from_dict(s)


def image_to_dict(x: Image) -> Any:
    return to_class(Image, x)
