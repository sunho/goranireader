#
# Copyright © 2019 Sunho Kim. All rights reserved.
#

import hug
import time
from gorani.routes import word
from gorani.datadb import DataDB

for i in range(0,10):
    while True:
        try:
            data_db = DataDB(addr='cassandra', port=9042)
            word.init(data_db)
        except Exception as e:
            print(e)
            print('connection error')
            time.sleep(10)
            continue
        break

@hug.extend_api('/word')
def words():
    return [word]
