import functools
import time

from flask import (
    Blueprint, g, request, session, jsonify, make_response, Response
)
from werkzeug.security import check_password_hash, generate_password_hash
from werkzeug.exceptions import abort
from sqlalchemy import Table
from .env import valid_auth

from .db import get_db

bp = Blueprint('auth', __name__, url_prefix='/auth')


@bp.route('/register', methods=['POST'])
def register():
    if 'Auth-Key' in request.headers:
        auth_key = request.headers['Auth-Key']
        if valid_auth(auth_key):
            if request.method == 'POST':
                if not request.is_json:  # JSON control.
                    return make_response(jsonify(
                        {"message": "Request body must be JSON."}), 400)

                json_data = request.get_json()
                if 'name' in json_data and 'surname' in json_data and\
                        'password' in json_data and 'email' in json_data and 'date_of_birth' in json_data:
                    name = json_data['name']
                    surname = json_data['surname']
                    password_plain = json_data['password']
                    email = json_data['email']
                    dob = json_data['date_of_birth']

                    db = get_db()
                    con, engine, metadata = db['con'], db['engine'], db['metadata']
                    users = Table('User', metadata, autoload=True)

                    msg = {"message": "Something went wrong."}
                    if not name or not surname or not password_plain or not email or not dob:
                        msg = {"message": "Error: Missing parameters!"}
                        return make_response(jsonify(msg, 400))

                    if users.select(users.c.email == email).execute().first():
                        msg = {"message": "There is an existing user with this e-mail address!"}
                        return make_response(jsonify(msg, 400))

                    con.execute(users.insert(), name=name, surname=surname, email=email,
                                password=generate_password_hash(password_plain), date_of_birth=dob,
                                created_at=int(time.time()))
                    msg = {"message": "You have registered successfully!"}
                    return make_response(jsonify(msg, 200))
                else:
                    return make_response(jsonify({"message": "Invalid parameters."}), 400)
            else:
                return Response(status=405)
        else:
            return Response(status=401)
    else:
        return Response(status=401)


@bp.route('/login', methods=['POST'])
def login():
    password = request.form.get('password')
    email = request.form.get('email')

    msg = ""
    if not email or not password:
        msg = {"status": {"type": "failure", "message": "Missing Data"}}
        abort(400, msg)

    db = get_db()
    con, engine, metadata = db['con'], db['engine'], db['metadata']
    users = Table('User', metadata, autoload=True)
    user = users.select(users.c.email == email).execute().first()

    if user is None or not check_password_hash(user['password'], password):
        msg = {"status": {"type": "failure", "message": "Username or password incorrect"}}
        abort(400, msg)
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
