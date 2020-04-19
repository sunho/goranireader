from metaflow import FlowSpec, step, IncludeFile

from dataserver.dag import GoraniFlowSpec
from dataserver.dag.decorators import pip
from dataserver.dag.deps import deps

from dataserver.models.config import Config
from dataserver.service.s3 import S3Service


class DownloadLog(GoraniFlowSpec):
    @step
    def start(self):
        import yaml
        self.config = Config(**yaml.load(self.config_file))

        self.next(self.download_firebase)

    @pip(libraries={
        'firebase-admin': '4.0.1'
    })
    @step
    def download_firebase(self):
        from dataserver.service.firebase import FirebaseService
        service = FirebaseService(self.config)
        self.books = service.fetch_books()
        self.users = service.fetch_users()

        self.next(self.download_logs)

    @step
    def download_logs(self):
        service = S3Service(self.config)
        self.logs = service.fetch_client_event_logs()

        self.next(self.end)

    @step
    def end(self):
        pass


if __name__ == '__main__':
    DownloadLog()
