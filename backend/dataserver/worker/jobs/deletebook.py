from worker.shared import Job, JobContext

class DeleteBook(Job):
    def __init__(self, context: JobContext):
        Job.__init__(self, context)

    def delete_all(self):
        for id in self.context.data_db.get_book_ids():
            self.delete_one(id)

    def delete_one(self, id):
        self.context.data_db.delete_book(id)
