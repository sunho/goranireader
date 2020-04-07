import boto3
import json
from datetime import datetime

import sys

topic_arn = 'arn:aws:sns:ap-northeast-2:926877676119:notify-discord'

def log_msg(flow, info, error):
    client = boto3.client('sns')
    response = client.publish(
        TopicArn = topic_arn,
        Message = json.dumps({
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

if __name__ == '__main__':
    log_msg(sys.argv[1], 'ERROR', True)