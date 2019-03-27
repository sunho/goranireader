import click

@click.group()
def cli():
    pass

@cli.command()
@click.option('--all', is_flag=True, help='Delete all books')
@click.option('--id', default=1, help='The id of book')
def deletebook(all, id):
    from worker.jobs import DeleteBook
    job = DeleteBook()
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
def createbook(all, id):
    from worker.sparkjobs.admin import CreateBook
    job = CreateBook()
    if all:
        job.create_all()
    else:
        job.create_one(id)

from worker.sparkjobs.compute import ComputeCosineSimilarity
@sparkjob.command()
@click.option('--type', default=ComputeCosineSimilarity.SIMILARITY_TYPE, help='Type of similarity')
def computesimilarity(type):
    if type == ComputeCosineSimilarity.SIMILARITY_TYPE:
        job = ComputeCosineSimilarity()
        job.compute()
    else:
        print('no such similarity type')


if __name__ == '__main__':
    cli()
