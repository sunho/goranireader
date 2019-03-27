from worker.shared import Job

class DeleteBook(Job):
    def __init__(self):
        Job.__init__(self)

    def delete_all(self):
        for id in self.data_db.get_book_ids():
            self.delete_one(id)

    def delete_one(self, id):
        self.data_db.delete_book(id)
