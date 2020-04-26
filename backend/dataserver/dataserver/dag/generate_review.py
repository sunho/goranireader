from metaflow import FlowSpec, step, IncludeFile, conda_base, Flow

from dataserver.job.review import decide_review_words, decide_target_words, serialize_review_words_df, \
    serialize_stats_df, combine_serialized_dfs
from dataserver.dag import deps, GoraniFlowSpec
import time

from dataserver.models.config import Config


class GenerateReview(GoraniFlowSpec):
    """
    리뷰 게임을 만듭니다.

    의존: Download, PreprocessPaginate, GenerateStats, PredictVocab

    start -> generate_review -> end 순으로 실행됩니다.

    Attributes
    ------------
    review_df : 만들어진 리뷰 게임입니다.
    """

    @step
    def start(self):
        """
        초기화
        """
        flow = Flow('Download').latest_successful_run
        print('using users data from flow: %s' % flow.id)

        self.users = flow.data.users
        self.vocab_skills = flow.data.vocab_skills


        flow = Flow('PreprocessPaginate').latest_successful_run
        print('using signals data from flow: %s' % flow.id)

        self.clean_pages_df = flow.data.clean_pages_df

        flow = Flow('GenerateStats').latest_successful_run
        print('using users data from flow: %s' % flow.id)

        self.last_session_df = flow.data.last_session_df
        self.session_info_df = flow.data.session_info_df

        flow = Flow('PredictVocab').latest_successful_run
        print('using vocab data from flow: %s' % flow.id)

        self.unknown_words_df = flow.data.unknown_words_df

        import yaml
        self.config = Config(**yaml.load(self.config_file))

        self.next(self.generate_review)

    @step
    def generate_review(self):
        """
        PredictVocab에서 예측한 유저의 어휘로 리뷰게임을 만듭니다.
        """
        words_df = decide_review_words(self.unknown_words_df, self.vocab_skills, self.last_session_df, 24*5)
        target_df = decide_target_words(words_df)

        review_words_df = serialize_review_words_df(words_df, self.clean_pages_df, target_df)
        session_info_df = self.session_info_df
        session_info_df = session_info_df.loc[(time.time() - session_info_df['start']) <= (14*24*60*60)]
        stats_df = serialize_stats_df(session_info_df)
        self.review_df = combine_serialized_dfs(stats_df, review_words_df, self.last_session_df, session_info_df)

        self.next(self.end)

    @step
    def end(self):
        """
        마무리
        """
        pass


if __name__ == '__main__':
    GenerateReview()
