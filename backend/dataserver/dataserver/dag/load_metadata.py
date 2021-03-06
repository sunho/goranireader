from metaflow import FlowSpec, step, IncludeFile, conda_base

from dataserver.dag import GoraniFlowSpec
from dataserver.models.vocab_skill import VocabSkill
from dataserver.dag import deps

from dataserver.models.config import Config

class LoadMetadata(GoraniFlowSpec):
    @step
    def start(self):
        import yaml
        self.config = Config(**yaml.load(self.config_file))

        self.next(self.download_vocab_skills)

    @step
    def download_vocab_skills(self):
        import yaml
        from dataserver.service.s3 import S3Service
        service = S3Service(self.config)

        self.vocab_skills = [VocabSkill(**yaml.load(buf))
                             for buf in service.fetch_all_files(self.config.vocab_skills_s3_bucket)]

        self.next(self.end)

    @step
    def end(self):
        pass


if __name__ == '__main__':
    LoadMetadata()
