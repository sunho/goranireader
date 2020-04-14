import click
from dataserver.booky.book import read_epub, Book
from dataserver.service.nlp import NLPService
from dataserver.service.notification import NotificationService
from dataserver.models.config import Config
import pandas as pd
import json
import subprocess

import sys
import yaml

import sys, os
sys.path.append(os.getcwd())


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
@click.argument('name')
@click.argument('importance')
@click.argument('path')
def csv2yaml(name, importance, path):
    nlp_service = NLPService()
    df = pd.read_csv(path)
    words = df['word'].map(nlp_service.stem).unique().tolist()
    out = {
        'name': name,
        'importance': float(importance),
        'words': words
    }
    with open(path+'.yaml', 'w') as f:
        yaml.dump(out, f)

def execute(cmd):
    popen = subprocess.Popen(cmd, stdout=subprocess.PIPE, universal_newlines=True)
    for stdout_line in iter(popen.stdout.readline, ""):
        yield stdout_line
    popen.stdout.close()
    return_code = popen.wait()
    if return_code:
        raise subprocess.CalledProcessError(return_code, cmd)

@cli.command()
@click.argument('flow')
def run(flow):
    try:
        for path in execute([sys.executable, 'dag/' + flow + '.py', "--environment=conda", "--no-pylint", "run"]):
            print(path, end="")
    except subprocess.CalledProcessError as e:
        with open('config.yaml') as f:
            service = NotificationService(config=Config(**yaml.load(f)))
            service.complete_flow(flow, "ERROR", True)
        raise
if __name__ == '__main__':
    cli()