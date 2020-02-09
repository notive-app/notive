import functools
import time

from flask import (
    Blueprint, g, request, session, jsonify
)
from werkzeug.security import check_password_hash, generate_password_hash
from sqlalchemy import Table

from .db import get_db

bp = Blueprint('auth', __name__, url_prefix='/auth')


@bp.route('/register', methods=['POST'])
def register():
    name = request.form.get('name')
    surname = request.form.get('surname')
    password = request.form.get('password')
    email = request.form.get('email')
    date_of_birth = request.form.get('date_of_birth')

    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    users = Table('User', metadata, autoload=True)

    msg = ""
    if not name or not surname or not password or not email or not date_of_birth:
        msg = {"status": {"type": "failure", "message": "missing data"}}
        return jsonify(msg)

    if users.select(users.c.email == email).execute().first():
        msg = {"status": {"type": "failure", "message": "email already taken"}}
        return jsonify(msg)

    con.execute(users.insert(), name=name, surname=surname, email=email, password=generate_password_hash(password)
                , date_of_birth=date_of_birth, created_at=int(time.time()))

    msg = {"status": {"type": "success", "message": "You have registered"}}
    return jsonify(msg)


@bp.route('/login', methods=['POST'])
def login():
    password = request.form.get('password')
    email = request.form.get('email')

    msg = ""
    if not email or not password:
        msg = {"status": {"type": "failure", "message": "Missing Data"}}
        return jsonify(msg)

    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    users = Table('User', metadata, autoload=True)
    user = users.select(users.c.email == email).execute().first()

    if user is None or not check_password_hash(user['password'], password):
        msg = {"status": {"type": "failure", "message": "Username or password incorrect"}}
    else:
        msg = {"status": {"type": "success",
                          "message": "You logged in"},
               "data": {"user": {"email": user['email'],
                                 "name": user['name'],
                                 "surname": user['surname']}
                        }}

        session.clear()
        session['user_id'] = user['id']

    return jsonify(msg)


@bp.before_app_request
def load_logged_in_user():
    user_id = session.get('user_id')

    if user_id is None:
        g.user = None
    else:
        db = get_db()
        con, engine, metadata = db['con'], db['engine'], db['metadata']
        users = Table('User', metadata, autoload=True)
        g.user = users.select(users.c.id == user_id).execute().first()


@bp.route('/logout')
def logout():
    session.clear()


def login_required(view):
    @functools.wraps(view)
    def wrapped_view(**kwargs):
        if g.user is None:
            msg = {"status": {"type": "failure", "message": "Login is required!"}}
            return jsonify(msg)

        return view(**kwargs)

    return wrapped_view
