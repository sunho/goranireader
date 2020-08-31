from metaflow import FlowSpec, step, IncludeFile, conda_base, Flow

from dataserver.job.stats import extract_session_info_df, extract_last_session_df, calculate_vocab_skills
from dataserver.dag import deps

from dataserver.models.config import Config
from dataserver.service.user import UserService
from dataserver.dag import GoraniFlowSpec

class GenerateStats(GoraniFlowSpec):
    @step
    def start(self):
        flow = Flow('DownloadLog').latest_successful_run
        print('using users data from flow: %s' % flow.id)

        self.users = flow.data.users


        flow = Flow('LoadMetadata').latest_successful_run
        print('using vocab skills data from flow: %s' % flow.id)

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
        self.vocab_skill_df = calculate_vocab_skills(self.known_words_df, self.vocab_skills)
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
