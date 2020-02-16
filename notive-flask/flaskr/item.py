import functools
import time

from flask import (
    Blueprint, g, request, jsonify, make_response, Response
)
from sqlalchemy import Table
from sqlalchemy.sql import and_
from werkzeug.exceptions import abort
from .list import get_list
from .util import validate_auth_key, get_json_from_keys
from .db import get_db
from .auth import login_required
from .list import get_list
bp = Blueprint('item', __name__, url_prefix='/item')


@bp.route('/<int:list_id>', methods=['GET'])
@login_required
def index(list_id):
    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    item_table = Table('Item', metadata, autoload=True)
    user = g.user

    user_list, status = get_list(list_id)
    if user_list is None or status is 404:
        msg = {"message": "List does not exist!"}
        return make_response(jsonify(msg), status)
    elif status is 403:
        msg = {"message": "List is not yours!"}
        return make_response(jsonify(msg), status)
    else:
        result = dict()
        result["items"] = []
        count = 0
        items = item_table.select(item_table.c.list_id == list_id).execute()

        for i in items:
            result["items"].append(dict(i))
            count += 1

        result["number_of_items"] = count

        return make_response(jsonify(
            {"message": "Success.",
             "data": result}), 200)


@bp.route('/create', methods=['POST'])
@login_required
def create():
    if not validate_auth_key(request):
        return Response(status=401)
    else:
        json_data = get_json_from_keys(request, ['name', 'list_id'])
        if json_data is False:
            return make_response(jsonify(
                {"message": "Request body must be JSON."}), 400)
        elif json_data is None:
            return make_response(jsonify({"message": "Invalid parameters."}), 400)
        else:
            name = json_data['name']
            list_id = json_data['list_id']
            created_at = int(time.time())

            if name is None:
                msg = {"message": "Please provide a name for the item."}
                return make_response(jsonify(msg), 400)

            user_list, status = get_list(list_id)
            if user_list is None or status is 404:
                msg = {"message": "List does not exist!"}
                return make_response(jsonify(msg), status)
            elif status is 403:
                msg = {"message": "List is not yours!"}
                return make_response(jsonify(msg), status)
            else:
                list_name = user_list['name']
                db = get_db()
                con, engine, metadata = db['con'], db['engine'], db['metadata']
                item_table = Table('Item', metadata, autoload=True)
                res = con.execute(item_table.insert(), name=name, list_id=list_id, created_at=created_at)
                data = {'item_id': res.lastrowid}
                msg = {"message": "An item has been successfully added to list named '" + list_name + "'.",
                       "data": data}
                return make_response(jsonify(msg), 200)


def get_item(list_id, item_id, check_user=True):
    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    item_table = Table('Item', metadata, autoload=True)
    list_table = Table('List', metadata, autoload=True)
    joined_table = item_table.join(list_table, list_table.c.id == item_table.c.list_id)
    item = joined_table.select(and_(item_table.c.id == item_id, list_table.c.id == list_id)).execute().first()

    if not item:
        status = 404
        return item, status
    elif check_user and item['user_id'] != g.user['id']:
        status = 403
        return item, status
    elif item is not None:
        status = 200
        return item, status

    return item, 500


@bp.route('/update', methods=['PUT'])
@login_required
def update():
    if not validate_auth_key(request):
        return Response(status=401)
    else:
        json_data = get_json_from_keys(request, ['name', 'list_id', 'item_id'])
        if json_data is False:
            return make_response(jsonify(
                {"message": "Request body must be JSON."}), 400)
        elif json_data is None:
            return make_response(jsonify({"message": "Invalid parameters."}), 400)
        else:
            name = json_data['name']
            list_id = json_data['list_id']
            item_id = json_data['item_id']

            if name is None:
                msg = {"message": "Please provide a name!"}
                return make_response(jsonify(msg), 400)
            if list_id is None or item_id is None:
                msg = {"message": "Please provide the list ID and the item ID."}
                return make_response(jsonify(msg), 400)

            user_item, status = get_item(list_id, item_id)
            if user_item is None or status is 404:
                msg = {"message": "Item does not exist!"}
                return make_response(jsonify(msg), status)
            elif status is 403:
                msg = {"message": "Item is not yours!"}
                return make_response(jsonify(msg), status)
            else:
                db = get_db()
                con, engine, metadata = db['con'], db['engine'], db['metadata']
                item_table = Table('Item', metadata, autoload=True)
                con.execute(item_table.update().where(item_table.c.id == item_id).values(name=name))

                msg = {"message": "Success! Item name is updated."}
                return make_response(jsonify(msg), 200)


@bp.route('/check', methods=['PUT'])
@login_required
def check():
    if not validate_auth_key(request):
        return Response(status=401)
    else:
        json_data = get_json_from_keys(request, ['list_id', 'item_id'])
        if json_data is False:
            return make_response(jsonify(
                {"message": "Request body must be JSON."}), 400)
        elif json_data is None:
            return make_response(jsonify({"message": "Invalid parameters."}), 400)
        else:
            list_id = json_data['list_id']
            item_id = json_data['item_id']

            if list_id is None or item_id is None:
                msg = {"message": "Please provide the list ID and the item ID."}
                return make_response(jsonify(msg), 400)

            user_item, status = get_item(list_id, item_id)
            if user_item is None or status is 404:
                msg = {"message": "Item does not exist!"}
                return make_response(jsonify(msg), status)
            elif status is 403:
                msg = {"message": "Item is not yours!"}
                return make_response(jsonify(msg), status)
            else:
                db = get_db()
                con, engine, metadata = db['con'], db['engine'], db['metadata']
                item_table = Table('Item', metadata, autoload=True)
                con.execute(item_table.update().where(item_table.c.id == item_id).values(is_done=1,
                                                                                         finished_at=int(time.time())))

                msg = {"message": "Item is marked as complete!"}
                return make_response(jsonify(msg), 200)


@bp.route('/uncheck', methods=['PUT'])
@login_required
def uncheck():
    if not validate_auth_key(request):
        return Response(status=401)
    else:
        json_data = get_json_from_keys(request, ['list_id', 'item_id'])
        if json_data is False:
            return make_response(jsonify(
                {"message": "Request body must be JSON."}), 400)
        elif json_data is None:
            return make_response(jsonify({"message": "Invalid parameters."}), 400)
        else:
            list_id = json_data['list_id']
            item_id = json_data['item_id']

            if list_id is None or item_id is None:
                msg = {"message": "Please provide the list ID and the item ID."}
                return make_response(jsonify(msg), 400)

            user_item, status = get_item(list_id, item_id)
            if user_item is None or status is 404:
                msg = {"message": "Item does not exist!"}
                return make_response(jsonify(msg), status)
            elif status is 403:
                msg = {"message": "Item is not yours!"}
                return make_response(jsonify(msg), status)
            else:
                db = get_db()
                con, engine, metadata = db['con'], db['engine'], db['metadata']
                item_table = Table('Item', metadata, autoload=True)
                con.execute(item_table.update().where(item_table.c.id == item_id).values(is_done=0,
                                                                                         finished_at=None))

                msg = {"message": "Item is marked as not completed!"}
                return make_response(jsonify(msg), 200)


@bp.route('/delete', methods=['DELETE'])
@login_required
def delete():
    if not validate_auth_key(request):
        return Response(status=401)
    else:
        json_data = get_json_from_keys(request, ['list_id', 'item_id'])
        if json_data is False:
            return make_response(jsonify(
                {"message": "Request body must be JSON."}), 400)
        elif json_data is None:
            return make_response(jsonify({"message": "Invalid parameters."}), 400)
        else:
            list_id = json_data['list_id']
            item_id = json_data['item_id']

            if list_id is None or item_id is None:
                msg = {"message": "Please provide the list ID and the item ID."}
                return make_response(jsonify(msg), 400)

            user_item, status = get_item(list_id, item_id)
            if user_item is None or status is 404:
                msg = {"message": "Item does not exist!"}
                return make_response(jsonify(msg), status)
            elif status is 403:
                msg = {"message": "Item is not yours!"}
                return make_response(jsonify(msg), status)
            else:
                db = get_db()
                con, engine, metadata = db['con'], db['engine'], db['metadata']
                item_table = Table('Item', metadata, autoload=True)
                con.execute(item_table.delete().where(item_table.c.id == item_id))

                msg = {"message": "Item is deleted succesfully!"}
                return make_response(jsonify(msg), 200)
