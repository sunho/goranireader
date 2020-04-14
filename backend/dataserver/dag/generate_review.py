from metaflow import FlowSpec, step, IncludeFile, conda_base, Flow

from dataserver.job.review import decide_review_words, decide_target_words, serialize_review_words_df, \
    serialize_stats_df, combine_serialized_dfs
from dataserver.models.vocab_skill import VocabSkill
from dataserver.job.stats import extract_session_info_df, extract_last_session_df, calculate_vocab_skills
from dataserver.service.notification import NotificationService
from dag.decorators import pip
from dag.deps import deps
import time

from dataserver.models.config import Config
from dataserver.service.s3 import S3Service
from dataserver.service.user import UserService


@conda_base(libraries= deps)
class GenerateReview(FlowSpec):
    config_file = IncludeFile(
        'config',
        is_text=False,
        help='Config Key File',
        default='./config.yaml')

    @step
    def start(self):
        flow = Flow('DownloadLog').latest_successful_run
        print('using users data from flow: %s' % flow.id)

        self.users = flow.data.users

        flow = Flow('GenerateStats').latest_successful_run
        print('using users data from flow: %s' % flow.id)

        self.last_session_df = flow.data.last_session_df
        self.session_info_df = flow.data.session_info_df

        flow = Flow('LoadMetadata').latest_successful_run
        print('using vocab skills data from flow: %s' % flow.id)

        self.vocab_skills = flow.data.vocab_skills

        flow = Flow('PredictVocab').latest_successful_run
        print('using vocab data from flow: %s' % flow.id)

        self.unknown_words_df = flow.data.unknown_words_df

        flow = Flow('PreprocessPaginate').latest_successful_run
        print('using signals data from flow: %s' % flow.id)

        self.clean_pages_df = flow.data.clean_pages_df

        import yaml
        self.config = Config(**yaml.load(self.config_file))

        self.next(self.generate_review)

    @step
    def generate_review(self):
        words_df = decide_review_words(self.unknown_words_df, self.vocab_skills, self.last_session_df, 24*4)
        target_df = decide_target_words(words_df)

        review_words_df = serialize_review_words_df(words_df, self.clean_pages_df, target_df)
        session_info_df = self.session_info_df
        session_info_df = session_info_df.loc[(time.time() - 14*24*60*60) <= session_info_df['start']]
        stats_df = serialize_stats_df(session_info_df)
        self.review_df = combine_serialized_dfs(stats_df, review_words_df, self.last_session_df, session_info_df)

        self.next(self.end)

    @step
    def end(self):
        service = NotificationService(self.config)
        service.complete_flow("Generate Review", "", False)


if __name__ == '__main__':
    GenerateReview()
