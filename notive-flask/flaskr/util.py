# from flask import request
from .env import AUTH_KEY


#  Misc. Functions
def valid_auth(auth_key):
    if auth_key != AUTH_KEY:
        return False
    return True


def validate_auth_key(request):
    if 'Authorization' in request.headers:
        auth_key = request.headers['Authorization']
        if not valid_auth(auth_key):
            return False
        else:
            return True
    else:
        return False


def get_json_from_keys(request, keys):
    if request.is_json:
        json_data = request.get_json()
        values = {}
        for key in keys:
            if key not in json_data:
                return None
            values[key] = json_data[key]
        return values
    else:
        return False
