import click
from dataserver.booky.book import read_epub, Book
import json
import subprocess
import sys

@click.group()
def cli():
    pass

@cli.command()
@click.argument('path')
def epub2xml(path):
    from xml.dom import minidom
    cbook = read_epub(path)
    buf = minidom.parseString(cbook.to_xml().decode('utf-8')).toprettyxml(indent="   ")
    with open(path + ".xml", "w") as f:
        f.write(buf)

@cli.command()
@click.argument('path')
def epub2book():
    click.echo('Dropped the database')

@cli.command()
@click.argument('path')
def xml2book(path):
    book = Book.read_xml(path)
    buf = book.to_dict()
    with open(path + ".book", "w") as f:
        f.write(json.dumps(buf))

@cli.command()
@click.argument('flow')
def run(flow):
    subprocess.run([sys.executable, flow, "--environment=conda", "--no-pylint", "run"])