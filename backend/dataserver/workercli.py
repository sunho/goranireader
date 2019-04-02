import click

@click.group()
def cli():
    pass

from gorani.shared import JobContext, SparkJobContext, StreamJobContext

def create_context() -> JobContext:
    return JobContext()

def create_spark_context() -> SparkJobContext:
    return SparkJobContext()

def create_stream_context() -> StreamJobContext:
    return StreamJobContext(['localhost:9092'])

@cli.command()
@click.option('--all', is_flag=True, help='Delete all books')
@click.option('--id', default=1, help='The id of book')
def delete_book(all, id):
    from gorani.jobs import DeleteBook
    job = DeleteBook(create_context())
    if all:
        job.delete_all()
    else:
        job.delete_one(id)

@cli.group()
def sparkjob():
    pass

@sparkjob.command()
@click.option('--all', is_flag=True, help='Process all files that ends with .epub in input folder')
@click.option('--id', default=1, help='The id in name of epub file')
def create_book(all, id):
    from gorani.jobs.sparkjobs.admin import CreateBook
    job = CreateBook(create_spark_context())
    if all:
        job.create_all()
    else:
        job.create_one(id)

from gorani.jobs.sparkjobs.compute import ComputeCosineSimilarity
@sparkjob.command()
@click.option('--type', default=ComputeCosineSimilarity.SIMILARITY_TYPE, help='Type of similarity')
def compute_similarity(type):
    if type == ComputeCosineSimilarity.SIMILARITY_TYPE:
        job = ComputeCosineSimilarity(create_spark_context())
        job.compute()
    else:
        print('no such similarity type')

from gorani.jobs.sparkjobs.compute import ComputeSimilarWord
@sparkjob.command()
def compute_similar_word():
    job = ComputeSimilarWord(create_spark_context())
    job.compute()

from gorani.jobs.sparkjobs.streams import StreamEvlogJob
@sparkjob.command()
def stream_evlog():
   job = StreamEvlogJob(create_stream_context())
   job.start()
   job.awaitTermination()

if __name__ == '__main__':
    cli()

