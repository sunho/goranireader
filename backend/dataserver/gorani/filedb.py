from minio import Minio

class FileDB:
    def __init__(self):
        host = os.environ['GORANI_FILE_DB_HOST']
        id = os.environ['GORANI_FILE_DB_ID']
        pw = os.environ['GORANI_FILE_DB_PW']
        self.client = Minio(host,
                  access_key=id,
                  secret_key=pw,
                  secure=True)