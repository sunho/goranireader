import pandera as pa



EventLogDataFrame = pa.DataFrameSchema({
    "time": pa.Column(),
    "serverTime": pa.Column(),
    "userId": pa.Column(pa.String),
    "classId": pa.Column(pa.String),
    "fireId": pa.Column(pa.String),
    "type": pa.Column(),
    "payload": pa.Column(),
}, strict=True)
"""raw 이벤트 로그를 나타냅니다.

Attributes
----------
time : str
    rfc3339 포맷입니다.
serverTime : str
    rfc3339 포맷입니다.
userId : str
classId : str
fireId : str
type : str
    이벤트 로그의 종류 
    더 자세한 내용은 공통타입 문서를 참조해주세요.
payload: str
"""

PagesDataFrame = pa.DataFrameSchema({
    "pageId": pa.Column(pa.Int),
    "time": pa.Column(pa.Int),
    "session": pa.Column(),
    "userId": pa.Column(pa.String),
    "cheat": pa.Column(pa.Bool),
    "eltime": pa.Column(),
    "wpm": pa.Column(),
    "from": pa.Column(pa.String),
    "rcId": pa.Column(pa.String),
    "sids": pa.Column(pa.Object),
    "words": pa.Column(pa.Object),
    "pos": pa.Column(pa.Object),
    "unknownWords": pa.Column(pa.Object),
    "unknownIndices": pa.Column(pa.Object)
}, strict=True)
""" 기본적인 전처리가 완료된 페이지 넘긴 로그입니다.

Attributes
----------
pageId : int
    이 데이터 프레임 내에서 auto_increment 아이디입니다.
    SignalDataFrame으로 계산한 내용을 조인시킬 때 유용하게 쓸 수 있습니다.
time : int
    unix timestamp
session : int
    학습 세션 아이디입니다. 각 유저마다 0부터 시작해서 오래될수록 1씩 늘어납니다.
    학습 세션의 최대 길이는 Config의 max_session_hours로 결정됩니다.
userId : int
cheat : bool
    제대로된 유저인지 여부. 이벤트 로그를 분석해서 얻은 것이므로 ground truth는 아닙니다.
eltime : float
    페이지를 넘기기 까지 걸린 시간입니다. 단위는 초 입니다.
wpm : float
    words per minute
from : str
    페이지 출처의 종류입니다.
    book 또는 review 입니다.
rcId : str
    페이지 출처의 아이디입니다.
    책의 아이디 또는 리뷰의 아이디 입니다. from필드를 보고 둘 중 어느것인지 알 수 있습니다.
sids : List[str]
    페이지에 포함되어 있는 문장 아이디입니다.
words : List[str]
    페이지에 있던 단어들 입니다.
pos : List[str]
    페이지에 있던 단어들의 품사 입니다.
unknownWords : List[str]
    유저가 찾아본 단어입니다.
unknownIndices : List[int]
    유저가 찾아본 단어의 words내 인덱스입니다.
"""

SignalDataFrame = pa.DataFrameSchema({
    "pageId": pa.Column(pa.Int),
    "word": pa.Column(pa.String),
    "signal": pa.Column(pa.Float),
    "userId": pa.Column(pa.String),
    "session": pa.Column(pa.Int),
    "cheat": pa.Column(pa.Bool),
    'wpm': pa.Column(pa.Float),
    "pos": pa.Column(pa.String),
    "time": pa.Column(pa.Int),
}, strict=True)
""" PagesDataFrame을 좀더 분석하기 쉽게 하기 위해 배열 형태였던 words와 관련 컬럼(pos, signal)을 explode한 것입니다.

예를 들어 PagesDataFrame이 아래와 같이 되어 있다면 (일부 칼럼은 편의를 위해 생략)

========== ==========  
  pageId     words   
========== ==========
  1          [ hello, world ]
  2          [ gorani, reader ]
========== ==========

SignalDataFrame은 아래와 같을 것 입니다.

========== ==========  
  pageId     word   
========== ==========
  1          hello
  1          world
  2          gorani
  2          reader
========== ==========

Attributes
----------
pageId : int
    PagesDataFrame의 pageId 참조
word : str
    단어
signal : int
    1 = 안 찾아봄
    0 = 찾아봄
userId : str
session : int
    PagesDataFrame의 session 참조
cheat : bool
    PagesDataFrame의 cheat 참조
wpm : float
    words per minute
pos : str
    품사
time : int
    unix timestramp
"""


CleanPagesDataFrame = pa.DataFrameSchema({
    "pageId": pa.Column(pa.Int),
    "time": pa.Column(pa.Int),
    "session": pa.Column(pa.Int),
    "userId": pa.Column(pa.String),
    "cheat": pa.Column(pa.Bool),
    "eltime": pa.Column(pa.Float),
    "wpm": pa.Column(pa.Float),
    "from": pa.Column(pa.String),
    "rcId": pa.Column(pa.String),
    "words": pa.Column(pa.Object),
    "knownWords": pa.Column(pa.Object),
    "unknownWords": pa.Column(pa.Object),
    "itemsJson": pa.Column(pa.String),
}, strict=True)
"""PagesDataFrame에서 각 페이지의 단어 리스트와 itemsJson을 추가한 것입니다. 유저가 접해봤으면서 특정 단어가 포함된 본문을 찾을때 유용합니다.

Attributes
----------
pageId : int
    PagesDataFrame의 pageId 참조
time : int
    unix timestamp
session : int
    PagesDataFrame의 session 참조
userId : str
cheat : bool
    PagesDataFrame의 cheat 참조
eltime : float
    페이지를 넘기기 까지 걸린 시간 (초)
wpm : float
    words per minute
from : str
    PagesDataFrame의 from 참조
rcId : str
    PagesDataFrame의 rcId 참조
words : List[str]
    해당 페이지에 있던 단어 리스트 (distinct)
knownWords : List[str]
    해당 페이지에서 찾아보지 않았던 단어 리스트 (distinct)
unknownWords : List[str]
    해당 페이지에서 찾아봤던 단어 리스트 (distinct)
itemsJson : str
    해당 페이지에 나왔던 문장을 앱에서 읽을 수 있는 형태로 바꿔둔 것입니다.
    더 자세히 설명하면, List[Item(공통타입의 booky 참조)]를 json으로 인코딩해둔 것입니다.
"""

SessionInfoDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "session": pa.Column(pa.Int),
    "start": pa.Column(pa.Int),
    "end": pa.Column(pa.Int),
    "wpm": pa.Column(pa.Float),
    "readWords": pa.Column(pa.Int),
    "unknownWords": pa.Column(pa.Int),
    "hours": pa.Column(pa.Float),
}, strict=True)
"""
Attributes
----------
userId : str
session : int
    PagesDataFrame의 session 참조
start : int
    세션 시작 시간
    unix timestamp
end : int
    세션 끝 시간
    unix timestamp
wpm : float
    평균 words per minute
readWords : int
    읽은 단어 수
unknownWords : int
    찾아본 단어 수
hours : float
"""


LastSessionDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "session": pa.Column(pa.Int),
    "end": pa.Column(pa.Int)
}, strict=True)

LastWordsDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "session": pa.Column(pa.Int),
    "lastWords": pa.Column(pa.String),
    "targetLastWords": pa.Column(pa.Int)
}, strict=True)

StatsDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "stats": pa.Column(pa.String)
}, strict=True)

ReviewDataFrame = pa.DataFrameSchema({
    "userId": pa.Column(pa.String),
    "review": pa.Column(pa.String)
}, strict=True)

# TODO use ast to automate this
# from dataserver.models.dataframe import gen_docs, {DataFrame}
# gen_docs({DataFrame})
def gen_docs(schema: pa.DataFrameSchema):
    cols = schema.columns.keys()
    cols_txt = '\n'.join(cols)
    print('"""\n\nAttributes\n----------\n' + cols_txt + '"""\n')

