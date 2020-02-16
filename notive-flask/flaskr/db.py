from sqlalchemy import create_engine, MetaData, Table
from .env import DB_DATABASE, DB_PORT, DB_HOST, DB_PASSWORD, DB_USERNAME
import click
from flask import current_app, g
from flask.cli import with_appcontext


def get_db():
    if 'engine' not in g:
        g.engine = create_engine('mysql://'+DB_USERNAME+':'+DB_PASSWORD+'@' + DB_HOST + ':' + str(DB_PORT) + '/' +
                                 DB_DATABASE, convert_unicode=True)
        g.metadata = MetaData(bind=g.engine)
        g.con = g.engine.connect()

    return {'con': g.con, 'engine': g.engine, 'metadata': g.metadata}


def close_db(e=None):
    con = g.pop('con', None)

    if con is not None:
        con.close()


def init_db():
    engine = get_db()['engine']

    with current_app.open_resource('schema.sql') as f:
        engine.execute(f.read().decode('utf8'))


@click.command('init-db')
@with_appcontext
def init_db_command():
    """Clear the existing data and create new tables."""
    init_db()
    click.echo('Initialized the database.')


def init_app(app):
    app.teardown_appcontext(close_db)
    app.cli.add_command(init_db_command)
