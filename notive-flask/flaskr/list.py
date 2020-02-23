import functools
import time

from flask import (
    Blueprint, g, request, jsonify, make_response, Response
)
from sqlalchemy import Table
from .util import validate_auth_key, get_json_from_keys
from .db import get_db
from .auth import login_required

bp = Blueprint('list', __name__, url_prefix='/list')


@bp.route('/', methods=['GET'])
@login_required
def index():
    if not validate_auth_key(request):
        return Response(status=401)
    else:
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
        msg = {"message": "Success!",
               "data": result}
        return make_response(jsonify(msg), 200)


@bp.route('/create', methods=['POST'])
@login_required
def create():
    if not validate_auth_key(request):
        return Response(status=401)
    else:
        json_data = get_json_from_keys(request, ['name'])
        if json_data is False:
            return make_response(jsonify(
                {"message": "Request body must be JSON."}), 400)
        elif json_data is None:
            return make_response(jsonify({"message": "Invalid parameters."}), 400)
        else:
            name = json_data['name']

            msg = {"message": "Something went wrong."}
            if not name:
                msg = {"message": "Error: Provide a name for this list!"}
                return make_response(jsonify(msg), 400)

            user_id = g.user['id']
            created_at = int(time.time())

            db = get_db()
            con, engine, metadata = db['con'], db['engine'], db['metadata']
            list_table = Table('List', metadata, autoload=True)

            res = con.execute(list_table.insert(), name=name, user_id=user_id, created_at=created_at)

            result = {'list_id': res.lastrowid,
                      'created_at': created_at}
            msg = {"message": "New list is created successfully!",
                   "data": result}
            return make_response(jsonify(msg), 200)


def get_list(l_id, check_user=True):
    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    list_table = Table('List', metadata, autoload=True)
    user_list = list_table.select(list_table.c.id == l_id).execute().first()

    if not user_list:
        status = 404
        return user_list, status
    elif check_user and user_list['user_id'] != g.user['id']:
        status = 403
        return user_list, status
    elif user_list is not None:
        status = 200
        return user_list, status

    return user_list, 500


@bp.route('/<int:l_id>', methods=['PUT'])
@login_required
def update(l_id):
    if not validate_auth_key(request):
        return Response(status=401)
    else:
        user_list, status = get_list(l_id)
        if user_list is None or status is 404:
            msg = {"message": "List does not exist!"}
            return make_response(jsonify(msg), status)
        elif status is 403:
            msg = {"message": "List is not yours!"}
            return make_response(jsonify(msg), status)
        else:
            json_data = get_json_from_keys(request, ['name'])
            if json_data is False:
                return make_response(jsonify(
                    {"message": "Request body must be JSON."}), 400)
            elif json_data is None:
                return make_response(jsonify({"message": "Invalid parameters."}), 400)
            else:
                name = json_data['name']

                if name is None:
                    msg = {"message": "Please provide a name!"}
                    return make_response(jsonify(msg), 400)

                db = get_db()
                con, engine, metadata = db['con'], db['engine'], db['metadata']
                list_table = Table('List', metadata, autoload=True)
                con.execute(list_table.update().where(list_table.c.id == l_id).values(name=name))

                msg = {"message": "Success! List name is updated."}
                return make_response(jsonify(msg), 200)


@bp.route('/<int:l_id>', methods=['DELETE'])
@login_required
def delete(l_id):
    if not validate_auth_key(request):
        return Response(status=401)
    else:
        user_list, status = get_list(l_id)
        if user_list is None or status is 404:
            msg = {"message": "List does not exist!"}
            return make_response(jsonify(msg), status)
        elif status is 403:
            msg = {"message": "List is not yours!"}
            return make_response(jsonify(msg), status)
        else:
            db = get_db()
            con, engine, metadata = db['con'], db['engine'], db['metadata']
            list_table = Table('List', metadata, autoload=True)
            con.execute(list_table.delete().where(list_table.c.id == l_id))

            msg = {"message": "List is deleted successfully."}
            return make_response(jsonify(msg), 200)
