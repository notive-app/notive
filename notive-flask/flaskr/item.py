import functools
import time

from flask import (
    Blueprint, g, request, jsonify
)
from sqlalchemy import Table
from werkzeug.exceptions import abort

from .db import get_db
from .auth import login_required

bp = Blueprint('item', __name__, url_prefix='/item')


@bp.route('/', methods=['GET'])
@login_required
def index():
    list_id = request.args.get('list_id')
    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    item_table = Table('Item', metadata, autoload=True)
    list_table = Table('List', metadata, autoload=True)
    user = g.user
    list = list_table.select(list_table.c.id == list_id).execute().first()

    if list is None:
        abort(404, "List does not exists!")

    if not list['user_id'] == user['id']:
        abort(401, "It is not your list!")

    result = dict()
    result["items"] = []
    count = 0
    items = item_table.select(item_table.c.list_id == list_id).execute()

    for i in items:
        result["items"].append(dict(i))
        count += 1

    result["number_of_items"] = count

    return jsonify(result)



@bp.route('/create', methods=['POST'])
@login_required
def create():
    list_id = request.args.get('list_id')
    name = request.form.get('name')
    user = g.user
    created_at = int(time.time())
    msg = ""

    if not name:
        msg = {"status": {"type": "failure", "message": "missing list name"}}
        abort(400, msg)

    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    list_table = Table('List', metadata, autoload=True)
    list = list_table.select(list_table.c.id == list_id).execute().first()

    if list is None:
        abort(404, "List does not exists!")

    if not list['user_id'] == user['id']:
        abort(401, "It is not your list!")

    item_table = Table('Item', metadata, autoload=True)

    con.execute(item_table.insert(), name=name, list_id=list_id, created_at=created_at)

    msg = {"status": {"type": "success", "message": "Item is created!"}}
    return jsonify(msg)


def get_item(id, check_user=True):
    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    item_table = Table('Item', metadata, autoload=True)
    item = item_table.select(item_table.c.id == id).execute().first()

    if item is None:
        abort(404, "Post id {0} doesn't exist.".format(id))

    list_table = Table('List', metadata, autoload=True)
    list = list_table.select(list_table.c.id == item["list_id"]).execute().first()

    if check_user and list['user_id'] != g.user['id']:
        abort(403)

    return item


@bp.route('/<int:id>/update', methods=['PUT'])
@login_required
def update(id):
    get_item(id)
    name = request.form.get('name')

    if name is None:
        abort(400, "New name required!")

    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    item_table = Table('Item', metadata, autoload=True)

    con.execute(item_table.update().where(item_table.c.id == id).values(name=name))

    msg = {"status": {"type": "success", "message": "Item name is changed!"}}
    return jsonify(msg)


@bp.route('/<int:id>/check', methods=['PUT'])
@login_required
def check(id):
    get_item(id)

    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    item_table = Table('Item', metadata, autoload=True)

    con.execute(item_table.update().where(item_table.c.id == id).values(is_done=1))

    msg = {"status": {"type": "success", "message": "Item is checked!"}}
    return jsonify(msg)


@bp.route('/<int:id>/delete', methods=['DELETE'])
@login_required
def delete(id):
    get_item(id)
    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    item_table = Table('Item', metadata, autoload=True)
    con.execute(item_table.delete().where(item_table.c.id == id))

    msg = {"status": {"type": "success", "message": "Item is deleted!"}}
    return jsonify(msg)




