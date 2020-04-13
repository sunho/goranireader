import boto3
import json
from datetime import datetime

dev = True

class NotificationService:
    def __init__(self, config):
        self.topic_arn = config.notify_topic_arn

    def complete_flow(self, flow: str, info: str, error: bool):
        client = boto3.client('sns')
        if not dev:
            response = client.publish(
                TopicArn=self.topic_arn,
                Message=json.dumps({
                    'embeds': [
                        {
                            "title": "Job completed",
                            "description": "Job completed",
                            "color": 3005550 if not error else 14177041,
                            "author": {
                                "name": flow,
                            },
                            "fields": [
                                {
                                    "name": "titme",
                                    "value": str(datetime.utcnow())
                                },
                                {
                                    "name": "error",
                                    "value": 'yes' if error else 'no'
                                },
                                {
                                    "name": "info",
                                    "value": info
                                }
                            ]
                        }
                    ]
                }),
            )
            print(response)