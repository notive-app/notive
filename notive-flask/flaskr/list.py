import functools
import time

from flask import (
    Blueprint, g, request, session, jsonify
)
from sqlalchemy import Table

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
    result = {}
    count = 0
    lists = list_table.select(list_table.c.user_id == user['id']).execute()

    for l in lists:
        result[count] = (dict(l))
        count += 1

    return jsonify(result)





