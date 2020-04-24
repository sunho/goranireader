# To use this code, make sure you
#
#     import json
#
# and then, to convert JSON from a string, do
#
#     result = review_from_dict(json.loads(json_string))

from typing import Dict, Any, TypeVar, Callable


T = TypeVar("T")


def from_dict(f: Callable[[Any], T], x: Any) -> Dict[str, T]:
    assert isinstance(x, dict)
    return { k: f(v) for (k, v) in x.items() }


def review_from_dict(s: Any) -> Dict[str, Any]:
    return from_dict(lambda x: x, s)


def review_to_dict(x: Dict[str, Any]) -> Any:
    return from_dict(lambda x: x, x)
