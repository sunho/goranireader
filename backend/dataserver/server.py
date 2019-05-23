#
# Copyright © 2019 Sunho Kim. All rights reserved.
#

import hug
from gorani.routes import word
from gorani.shared import DataDB

data_db = DataDB()
word.init(data_db)

@hug.extend_api('/word')
def words():
    return [word]
