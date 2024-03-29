from flask import Blueprint, request

# Models
from src.models.ModelAddress import ModelAddress

# Entities
from src.models.entities.Address import Address

# Security
from src.utils.Security import Security

# Database
from src.database.db_conection import DBConnection

# Database connection:
db = DBConnection()

address = Blueprint('address', __name__)


@address.route('/', methods=['GET'])
@Security.verify_session
def list_addresses(user_id):
    """
    List addresses for a specific user.

    Parameters:
    - user_id (str): The ID of the user whose addresses are to be listed.
    """
    if request.method == 'GET':
        response = ModelAddress.list_addresses(db.connection, user_id)
        return response


@address.route('/add', methods=['POST'])
@Security.verify_session
def add_new_address(user_id):
    """
    Add a new address for a user.

    Parameters:
        user_id (str): The unique identifier for the user.
        department(str): The department where the address is located.
        locality(str): The locality where the address is located.
        street_address(str): The street address of the address.
        number(str): The number of the address.
        type(str): The type of the address.
        additional_references(str): Additional references for the address.
    """
    if request.method == 'POST':
        data = request.json
        validation_error = ModelAddress.validate(data)
        if validation_error:
            return validation_error
        address = Address(department=data['department'],
                          locality=data['locality'],
                          street_address=data['street_address'],
                          number=data['number'],
                          type=data['type'],
                          additional_references=data['additional_references'])
        response = ModelAddress.add_address(db.connection, user_id, address)
        return response


@address.route('/<string:id>', methods=['GET'])
@Security.verify_session
def get_address(user_id, id):
    """
    Retrieves an address from the database based on its unique identifier.

    Parameters:
        user_id (str): The ID of the user making the request.
        id (str): The unique identifier for the address.
    """
    if request.method == 'GET':
        response = ModelAddress.get_address_by_id(db.connection, id)
        return response


@address.route('/update/<string:id>', methods=['PUT'])
@Security.verify_session
def update_address(user_id, id):
    """
    Updates an address in the database based on its unique identifier.

    Parameters:
    - user_id (str): The ID of the user making the request.
    - id (str): The unique identifier for the address.
    """
    if request.method == 'PUT':
        data = request.json
        validation_error = ModelAddress.validate(data)
        if validation_error:
            return validation_error
        address = Address(department=data['department'],
                          locality=data['locality'],
                          street_address=data['street_address'],
                          number=data['number'],
                          type=data['type'],
                          additional_references=data['additional_references'])
        response = ModelAddress.update_address(db.connection, id, address)
        return response


@address.route('/delete/<string:id>', methods=['DELETE'])
@Security.verify_session
def delete_address(user_id, id):
    """
    Deletes an address from the database based on its unique identifier.

    Parameters:
    - user_id (str): The ID of the user making the request.
    - id (str): The unique identifier for the address.
    """
    if request.method == 'DELETE':
        response = ModelAddress.delete_address(db.connection, id)
        return response
