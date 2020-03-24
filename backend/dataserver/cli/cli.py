import click

@click.group()
def cli():
    pass

@cli.command()
@click.argument('path')
def epub2xml():
    pass

@cli.command()
@click.argument('path')
def epub2book():
    click.echo('Dropped the database')

@cli.command()
@click.argument('path')
def xml2book():
    click.echo('Dropped the database')


if __name__ == '__main__':
    cli()