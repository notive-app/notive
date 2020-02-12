import functools
import time

from flask import (
    Blueprint, g, request, jsonify
)
from sqlalchemy import Table
from werkzeug.exceptions import abort

from .db import get_db
from .auth import login_required

bp = Blueprint('list', __name__, url_prefix='/list')


@bp.route('/', methods=['GET'])
@login_required
def index():
    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    list_table = Table('List', metadata, autoload=True)
    user = g.user
    result = dict()
    result["lists"] = []
    count = 0
    lists = list_table.select(list_table.c.user_id == user['id']).execute()

    for l in lists:
        result["lists"].append(dict(l))
        count += 1

    result["number_of_lists"] = count

    return jsonify(result)


@bp.route('/create', methods=['POST'])
@login_required
def create():
    name = request.form.get('name')
    user_id = g.user['id']
    created_at = int(time.time())
    msg = ""

    if not name:
        msg = {"status": {"type": "failure", "message": "missing list name"}}
        abort(400, msg)

    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    list_table = Table('List', metadata, autoload=True)

    con.execute(list_table.insert(), name=name, user_id=user_id, created_at=created_at)

    msg = {"status": {"type": "success", "message": "List is created!"}}
    return jsonify(msg)


def get_list(id, check_user=True):
    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    list_table = Table('List', metadata, autoload=True)
    list = list_table.select(list_table.c.id == id).execute().first()

    if list is None:
        abort(404, "Post id {0} doesn't exist.".format(id))

    if check_user and list['user_id'] != g.user['id']:
        abort(403)

    return list


@bp.route('/<int:id>/update', methods=['PUT'])
@login_required
def update(id):
    get_list(id)
    name = request.form.get('name')

    if name is None:
        abort(400, "New name required!")

    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    list_table = Table('List', metadata, autoload=True)

    con.execute(list_table.update().where(list_table.c.id == id).values(name=name))

    msg = {"status": {"type": "success", "message": "List name is changed!"}}
    return jsonify(msg)


@bp.route('/<int:id>/delete', methods=['DELETE'])
@login_required
def delete(id):
    get_list(id)
    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    list_table = Table('List', metadata, autoload=True)
    con.execute(list_table.delete().where(list_table.c.id == id))

    msg = {"status": {"type": "success", "message": "List is deleted!"}}
    return jsonify(msg)
