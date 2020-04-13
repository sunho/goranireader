from metaflow import FlowSpec, step, IncludeFile, conda_base

from dataserver.models.vocab_skill import VocabSkill
from dataserver.service.notification import NotificationService
from dag.decorators import pip
from dag.deps import deps

from dataserver.models.config import Config
from dataserver.service.s3 import S3Service

@conda_base(libraries= deps)
class LoadMetadata(FlowSpec):
    config_file = IncludeFile(
        'config',
        is_text=False,
        help='Config Key File',
        default='./config.yaml')

    @step
    def start(self):
        import yaml
        self.config = Config(**yaml.load(self.config_file))

        self.next(self.download_vocab_skills)

    @step
    def download_vocab_skills(self):
        import json
        from dataserver.service.s3 import S3Service
        service = S3Service(self.config)

        self.vocab_skills = [VocabSkill(**json.load(buf))
                             for buf in service.fetch_all_files(self.config.vocab_skills_s3_bucket)]

        self.next(self.end)

    @step
    def end(self):
        service = NotificationService(self.config)
        service.complete_flow("Load Metadata", "", False)


if __name__ == '__main__':
    LoadMetadata()
