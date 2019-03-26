import click
from miner.jobs.epubtodata import EpubToData

@click.group()
def cli():
    pass

@cli.command()
@click.option('--all', is_flag=True, help='Process all files that ends with .epub in input folder')
@click.option('--name', default='', help='The name of epub file')
def epubtodata(all, name):
    job = EpubToData()
    if all:
        job.convert_all()

if __name__ == '__main__':
    cli()