from metaflow import FlowSpec, step, IncludeFile, conda_base, Flow

from dataserver.booky import Book
from dataserver.job.review import decide_review_words, decide_target_words, serialize_review_words_df, \
    serialize_stats_df, combine_serialized_dfs
from dataserver.dag import deps, GoraniFlowSpec
import time
import msgpack
from dataserver.models.config import Config
from dataserver.models.vocab_skill import VocabSkill


class Download(GoraniFlowSpec):
    """
    데이터를 다운로드 합니다.

    Attributes:
        logs (list[EventLog]): 로그 데이터 입니다. EventLog는 공통타입입니다.
        users (Dict[str, dict]): 유저
        books (List[Book]): 책
        vocab_skills (List[VocabSkill]): 단어 셋 정보
    """

    data_file = IncludeFile(
        'data',
        is_text=False,
        help='Raw Data File',
        default='./data.msgpack')

    @step
    def start(self):
        data = msgpack.unpackb(self.data_file)
        self.logs = data['logs']
        self.users = data['users']

        self.books = [Book.from_dict(book) for book in data['books']]
        self.vocab_skills = [VocabSkill(**vc) for vc in data['vocab_skills']]

        self.next(self.end)

    @step
    def end(self):
        pass


if __name__ == '__main__':
    Download()
