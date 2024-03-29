from flask import Blueprint, request

# Models
from src.models.ModelProduct import ModelProduct

#  Entities
from src.models.entities.Products import Product

# Security
from src.utils.Security import Security

# Database connection
from src.database.db_conection import DBConnection

db = DBConnection()

product = Blueprint('product', __name__)


@product.route('/', methods=['GET'])
def get_products():
    """
    Obtains all products
    """
    if request.method == 'GET':
        response = ModelProduct.get_products(db.connection)
        return response


@product.route('/<string:id>', methods=['GET'])
def get_product(id):
    """
    Gets a product by its id

    Args:
        id (str): ID of the product
    """
    if request.method == 'GET':
        response = ModelProduct.get_product_by_id(db.connection, id)
        return response


@product.route('/create', methods=['POST'])
@Security.verify_admin
def create_product():
    """
    Create a new product
    """
    if request.method == 'POST':
        data = request.json
        valid_data = ModelProduct.validate(data)
        if valid_data:
            return valid_data
        product = Product(name=data['name'],
                          description=data['description'],
                          price=data['price'],
                          stock=data['stock'],
                          category=data['category'])
        response = ModelProduct.create(db.connection, product)
    return response


@product.route('/update/<string:id>', methods=['PUT'])
@Security.verify_admin
def update_product(id):
    """
    Upgrades an existing product

    Args:
        id (str): ID of the product to be updated
    """
    if request.method == 'PUT':
        data = request.json
        valid_data = ModelProduct.validate(data)
        if valid_data:
            return valid_data
        response = ModelProduct.update_product(db.connection, id, data)
        return response


@product.route('/delete/<string:id>', methods=['DELETE'])
@Security.verify_admin
def delete_product(id):
    """
    Deletes an existing product

    Args:
        id (str): ID of the product to be deleted
    """
    if request.method == 'DELETE':
        response = ModelProduct.delete_product(db.connection, id)
        return response
