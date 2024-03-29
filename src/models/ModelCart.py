from uuid import uuid4
from flask import jsonify


class ModelCart():

    @classmethod
    def get_cart(cls, db, user_id):
        """
        Get the user's shopping cart.

        Args:
            user_id (str): ID of the user whose cart is to be fetched.
        """
        try:
            cursor = db.cursor()
            cursor.callproc("Get_cart", (user_id,))
            for results in cursor.stored_results():
                result = results.fetchall()

            cart = []
            for item in result:
                cart.append({
                    "id": item[0],
                    "name": item[1],
                    "price": float(item[2]),
                    "quantity": item[3],
                    "total": item[4]
                })

            return jsonify({"success": True, "message": "Cart retrieved successfully", "cart": cart}), 200
        except Exception as e:
            return jsonify({"success": True, "error": str(e)}), 500
        finally:
            cursor.close()

    @classmethod
    def add_to_cart(cls, db, user_id, data):
        """
        Add a product to the user's shopping cart.

        Args:
            user_id (str): ID of the user to whom the product will be added.
            data (dict): Product data to be added, including 'product_id' and 'quantity'.

        """
        try:
            cursor = db.cursor()
            cart_id = str(uuid4())
            cursor.callproc(
                "Add_to_cart", (data['product_id'], user_id, data['quantity'], cart_id))
            for result in cursor.stored_results():
                message = result.fetchone()[0]
            if message == 'not_exist':
                return jsonify({"success": False, "message": "Product not found"}), 404
            elif message == 'success':
                db.commit()
                return jsonify({"success": True, "message": "Product successfully added to cart"}), 201
        except Exception as e:
            return jsonify({"success": True, "error": str(e)})
        finally:
            cursor.close()

    @classmethod
    def remove_to_cart(cls, db, user_id, product_id):
        """
        Remove a product from the user's shopping cart.

        Args:
            user_id (str): ID of the user from whom the product will be removed from the cart.
            product_id (str): ID of the product to be removed from the cart.
        """
        try:
            cursor = db.cursor()
            cursor.callproc("Remove_to_cart", (user_id, product_id))
            for result in cursor.stored_results():
                message = result.fetchone()[0]
            if message == 'not_exist':
                return jsonify({"success": False, "message": "Product is not in your cart"}), 404
            elif message == 'success':
                db.commit()
                return jsonify({"success": True, "message": "Product successfully removed from cart"}), 200
        except Exception as e:
            return jsonify({"success": True, "error": str(e)})
        finally:
            cursor.close()

    @classmethod
    def empty_cart(cls, db, user_id):
        cursor = db.cursor()
        try:
            cursor.callproc("Empty_cart", (user_id,))
            for result in cursor.stored_results():
                message = result.fetchone()[0]
            if message == 'not_exist':
                return jsonify({"success": False, "message": "User not found"}), 404
            db.commit()
            return jsonify({"success": True, "message": "Cart successfully emptied"}), 200
        except Exception as e:
            return jsonify({"success": True, "error": str(e)})
        finally:
            cursor.close()

    @staticmethod
    def validate(data):
        """
        Validate the provided data for adding a product to the cart.

        Args:
            data (dict): Product data to validate.
        """
        if not data:
            return jsonify({"success": False, "message": "No data provided"}), 400

        if 'product_id' not in data:
            return jsonify({"success": False, "message": "'product_id' field is required"}), 400
        elif not isinstance(data['product_id'], str) or len(data['product_id']) == 0:
            return jsonify({"success": False, "message": "'product_id' field must be a non-empty string"}), 400

        if 'quantity' not in data:
            return jsonify({"success": False, "message": "'quantity' field is required"}), 400
        elif not isinstance(data['quantity'], int) or isinstance(data['quantity'], bool) or data['quantity'] <= 0:
            return jsonify({"success": False, "message": "'quantity' field must be a number and greater than 0"}), 400

        return None
