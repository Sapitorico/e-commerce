from flask import Blueprint, request

# Models:
from src.models.ModelUser import ModelUser

# Entities
from src.models.entities.Users import User

# Database
from src.database.db_conection import DBConnection

# Database connection:
db = DBConnection()


auth = Blueprint('auth', __name__)
"""
This module handles authentication routes.
"""


@auth.route('/register', methods=['POST'])
def register():
    """
    Register a new user.

    This function handles the registration of a new user by receiving a POST request with user data in JSON format.
    It validates the data, creates a new User object, and registers it using the ModelUser class.

    Returns:
        dict: A dictionary containing the response from the registration process.This could be a success message or an error message, both in JSON format.
    """
    if request.method == 'POST':
        data = request.json
        validation_error = ModelUser.validate(data)
        if validation_error:
            return validation_error
        user = User(full_name=data.get('full_name'),
                    username=data.get('username'),
                    email=data.get('email'),
                    phone_number=data.get('phone_number'),
                    password=User.hash_password(data.get('password')))
        response = ModelUser.register(db.connection, user)
        return response


@auth.route('/login', methods=['POST'])
def login():
    """
    Log in an existing user.

    This function handles the login of an existing user by receiving a POST request with user data in JSON format.
    It validates the data, creates a new User object, and logs it in using the ModelUser class.

    Returns:
        dict: A dictionary containing the response from the login process. This could be a success message or an error message, both in JSON format.
    """
    if request.method == 'POST':
        data = request.json
        validation_error = ModelUser.validate_login(data)
        if validation_error:
            return validation_error
        user = User(email=data.get('email'),
                    password=data.get('password'))
        response = ModelUser.login(db.connection, user)
        return response
