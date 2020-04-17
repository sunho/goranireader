from metaflow import FlowSpec, step, IncludeFile, conda_base

from dataserver.service.notification import NotificationService
from dag.decorators import pip
from dag.deps import deps

from dataserver.models.config import Config
from dataserver.service.s3 import S3Service

@conda_base(libraries= deps)
class DownloadLog(FlowSpec):
    config_file = IncludeFile(
        'config',
        is_text=False,
        help='Config Key File',
        default='./config.yaml')

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
    def download_reviews(self):
        service = S3Service(self.config)
        self.reviews = service.fetch_reviews()

    @step
    def end(self):
        service = NotificationService(self.config)
        service.complete_flow("Download Logs", 'downloaded: %d' % len(self.logs), False)


if __name__ == '__main__':
    DownloadLog()
