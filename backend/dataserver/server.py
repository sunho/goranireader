import hug
from gorani.routes import words
from gorani.shared import DataDB

data_db = DataDB()
words.init(data_db)

@hug.extend_api('/words')
def words():
    return [words]
