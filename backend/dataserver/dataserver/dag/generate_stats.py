from metaflow import FlowSpec, step, IncludeFile, conda_base, Flow

from dataserver.job.stats import extract_session_info_df, extract_last_session_df, calculate_vocab_skills
from dataserver.dag import deps, GoraniFlowSpec

from dataserver.models.config import Config
from dataserver.service.user import UserService


class GenerateStats(GoraniFlowSpec):
    """
    간단한 통계를 구합니다.

    의존: Download, PreprocessPaginate, GenerateStats, PredictVocab

    start -> generate_review -> end 순으로 실행됩니다.

    Attributes
    ------------
    review_df : 만들어진 리뷰 게임입니다.
    """

    @step
    def start(self):
        flow = Flow('Download').latest_successful_run
        print('using users data from flow: %s' % flow.id)

        self.users = flow.data.users
        self.vocab_skills = flow.data.vocab_skills

        flow = Flow('PredictVocab').latest_successful_run
        print('using vocab data from flow: %s' % flow.id)

        self.known_words_df = flow.data.known_words_df

        flow = Flow('PreprocessPaginate').latest_successful_run
        print('using signals data from flow: %s' % flow.id)

        self.signals_df = flow.data.signals_df
        self.clean_pages_df = flow.data.clean_pages_df

        import yaml
        self.config = Config(**yaml.load(self.config_file))

        self.next(self.generate_stats)

    @step
    def generate_stats(self):
        user_service = UserService(self.users)
        self.session_info_df = extract_session_info_df(self.signals_df, self.clean_pages_df)
        self.last_session_df = extract_last_session_df(self.session_info_df,
                                                       user_service,
                                                       self.config.last_session_after_hours,
                                                       self.config.skip_session_hours)

        self.next(self.end)

    @step
    def end(self):
        pass


if __name__ == '__main__':
    GenerateStats()
