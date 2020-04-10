from concurrent import futures

import boto3
from botocore.exceptions import ClientError

from dataserver.models.config import Config

import json

class S3Service:
    def __init__(self, config: Config):
        self.s3 = boto3.client("s3")
        self.s3_rc = boto3.resource("s3")
        self.config = config

    def fetch_client_event_logs(self):
        bucket_name = self.config.client_event_logs_s3_bucket
        bufs = self.fetch_all_files(bucket_name)
        return [json.load(buf) for buf in bufs]

    def fetch_all_files(self, bucket_name: str, worker: int = 5):
        s3_result = self.s3.list_objects_v2(Bucket=bucket_name)
        file_list = []
        if 'Contents' in s3_result:
            for key in s3_result['Contents']:
                file_list.append(key['Key'])

            while s3_result['IsTruncated']:
                continuation_key = s3_result['NextContinuationToken']
                s3_result = self.s3.list_objects_v2(Bucket=bucket_name,
                    ContinuationToken=continuation_key)
                for key in s3_result['Contents']:
                    file_list.append(key['Key'])

        def _fetch(key):
            obj = self.s3.get_object(Bucket=bucket_name, Key=key)
            return obj["Body"]

        with futures.ThreadPoolExecutor(max_workers=worker) as executor:
            future_to_key = {executor.submit(_fetch, key): key for key in file_list}

            for future in futures.as_completed(future_to_key):
                exception = future.exception()

                if not exception:
                    yield future.result()
                else:
                    yield exception

    def exists(self, bucket, filename):
        try:
            self.s3_rc.Object(bucket, filename).load()
            return True
        except ClientError as e:
            if e.response['Error']['Code'] == "404":
                return False
            else:
                raise

    def upload(self, bucket, filename, payload):
        self.s3_rc.Object(bucket, filename).put(Body=payload)
        return "https://" + bucket + ".s3.ap-northeast-2.amazonaws.com/" + filename