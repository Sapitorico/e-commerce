-- MySQL Script generated by MySQL Workbench
-- Fri Mar 15 17:48:51 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema ecommerce_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ecommerce_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ecommerce_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `ecommerce_db` ;

-- -----------------------------------------------------
-- Table `ecommerce_db`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_db`.`users` (
  `id` VARCHAR(36) NOT NULL,
  `full_name` VARCHAR(150) NOT NULL,
  `username` VARCHAR(50) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `phone_number` VARCHAR(50) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `user_type` ENUM('admin', 'customer') NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  UNIQUE INDEX `full_name_UNIQUE` (`full_name` ASC) VISIBLE,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `phone_number_UNIQUE` (`phone_number` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ecommerce_db`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_db`.`categories` (
  `id` VARCHAR(36) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ecommerce_db`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_db`.`products` (
  `id` VARCHAR(36) NOT NULL,
  `name` VARCHAR(150) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  `stock` INT NULL DEFAULT NULL,
  `category_id` VARCHAR(36) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_products_category_id_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `fk_products_category_id`
    FOREIGN KEY (`category_id`)
    REFERENCES `ecommerce_db`.`categories` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ecommerce_db`.`cart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_db`.`cart` (
  `id` VARCHAR(36) NOT NULL,
  `customer_id` VARCHAR(36) NOT NULL,
  `product_id` VARCHAR(36) NOT NULL,
  `quantity` INT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_cart_customer_id_idx` (`customer_id` ASC) VISIBLE,
  INDEX `fk_cart_product_id_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `fk_cart_customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `ecommerce_db`.`users` (`id`),
  CONSTRAINT `fk_cart_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `ecommerce_db`.`products` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ecommerce_db`.`address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_db`.`address` (
  `id` VARCHAR(36) NOT NULL,
  `user_id` VARCHAR(36) NOT NULL,
  `state` VARCHAR(150) NOT NULL,
  `city` VARCHAR(150) NOT NULL,
  `address` TEXT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_address_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `ecommerce_db`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_db`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_db`.`orders` (
  `id` VARCHAR(36) NOT NULL,
  `customer_id` VARCHAR(36) NOT NULL,
  `address_id` VARCHAR(36) NOT NULL,
  `order_date` DATETIME NOT NULL,
  `status` ENUM('processing', 'shipped', 'canceled') NOT NULL DEFAULT 'processing',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_orders_customer_id_idx` (`customer_id` ASC) VISIBLE,
  INDEX `fk_orders_address_id_idx` (`address_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `ecommerce_db`.`users` (`id`),
  CONSTRAINT `fk_orders_address_id`
    FOREIGN KEY (`address_id`)
    REFERENCES `ecommerce_db`.`address` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ecommerce_db`.`order_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_db`.`order_details` (
  `id` VARCHAR(36) NOT NULL,
  `order_id` VARCHAR(36) NOT NULL,
  `product_id` VARCHAR(36) NOT NULL,
  `status` ENUM('pending', 'paid', 'cancelled', 'delivered', 'returned') NOT NULL DEFAULT 'pending',
  `cancelled_by` ENUM('client', 'administrator', 'expiration') NULL,
  `cancelled_reason` TEXT NULL,
  `quantity` INT NOT NULL,
  `unit_price` DECIMAL(10,2) NOT NULL,
  `total_price` DECIMAL(10,2) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_order_details_order_id_idx` (`order_id` ASC) VISIBLE,
  INDEX `fk_order_details_product_id_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_details_order_id`
    FOREIGN KEY (`order_id`)
    REFERENCES `ecommerce_db`.`orders` (`id`),
  CONSTRAINT `fk_order_details_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `ecommerce_db`.`products` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ecommerce_db`.`payment_details`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_db`.`payment_details` (
  `id` VARCHAR(36) NOT NULL,
  `order_id` VARCHAR(36) NOT NULL,
  `amount` DECIMAL(10,2) NOT NULL,
  `status` ENUM('pending', 'completed', 'failed') NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `method` ENUM('Mercado Pago', 'PayPal', 'Handy', 'Otro') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_pyment_details_order_id_idx` (`order_id` ASC) VISIBLE,
  CONSTRAINT `fk_payment_details_order_id`
    FOREIGN KEY (`order_id`)
    REFERENCES `ecommerce_db`.`order_details` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_db`.`product_reviews`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_db`.`product_reviews` (
  `id` VARCHAR(36) NOT NULL,
  `product_id` VARCHAR(36) NOT NULL,
  `user_id` VARCHAR(36) NOT NULL,
  `rating` INT NOT NULL,
  `comment` TEXT NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_reviews_product_id_idx` (`product_id` ASC) VISIBLE,
  INDEX `fk_reviews_user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_reviews_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `ecommerce_db`.`products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reviews_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `ecommerce_db`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_db`.`discounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_db`.`discounts` (
  `id` VARCHAR(36) NOT NULL,
  `discount` DECIMAL(5,2) NOT NULL,
  `expiration_date` DATE NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_db`.`product_discounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_db`.`product_discounts` (
  `id` VARCHAR(36) NOT NULL,
  `product_id` VARCHAR(36) NOT NULL,
  `discount_id` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  INDEX `fk_discount_product_id_idx` (`product_id` ASC) VISIBLE,
  INDEX `fk_discount_discount_id_idx` (`discount_id` ASC) VISIBLE,
  CONSTRAINT `fk_discount_product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `ecommerce_db`.`products` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_discount_discount_id`
    FOREIGN KEY (`discount_id`)
    REFERENCES `ecommerce_db`.`discounts` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce_db`.`taxes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce_db`.`taxes` (
  `id` VARCHAR(36) NOT NULL,
  `description` TEXT NOT NULL,
  `rate` DECIMAL(5,2) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;

USE `ecommerce_db` ;

-- -----------------------------------------------------
-- procedure Add_to_cart
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_to_cart`(
    IN p_product_id VARCHAR(36),
    IN p_user_id VARCHAR(36),
    IN p_quantity INT,
    IN p_cart_id VARCHAR(36)
)
BEGIN    
    DECLARE v_id VARCHAR(36);
    DECLARE current_quantity INT;

    IF NOT EXISTS (SELECT id FROM products WHERE id = p_product_id) THEN
        SELECT 'not_exist' AS message;
    ELSE
        SELECT id, quantity INTO v_id, current_quantity FROM cart WHERE customer_id = p_user_id AND product_id = p_product_id;
        IF v_id IS NOT NULL THEN
            UPDATE cart SET quantity = current_quantity + p_quantity WHERE id = v_id;
            SELECT 'success' AS message;
        ELSE
            INSERT INTO cart (id, customer_id, product_id, quantity)
            VALUES (p_cart_id, p_user_id , p_product_id, p_quantity);
            SELECT 'success' AS message;
        END IF;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Create_product
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Create_product`(
    IN p_id VARCHAR(36),
    IN p_name VARCHAR(255),
    IN p_description TEXT,
    IN p_price DECIMAL(10,2),
    IN p_stock INT,
    IN p_category_id VARCHAR(36),
    IN p_category VARCHAR(50)
)
BEGIN
    DECLARE v_category_id VARCHAR(36);
    
    IF EXISTS (SELECT * FROM products WHERE name = p_name) THEN
        SELECT 'already exist' AS result;
    ELSE
        SELECT id INTO v_category_id FROM categories WHERE name = p_category;
        
        IF v_category_id IS NULL THEN
            INSERT INTO categories (id, name) VALUES (p_category_id, p_category);
            SET v_category_id = p_category_id; 
        END IF;
        
        INSERT INTO products (id, name, description, price, stock, category_id, created_at, updated_at)
        VALUES (p_id, p_name, p_description, p_price, p_stock, v_category_id, NOW(), NOW());
        
        SELECT 'success' AS result;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Delete_product
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_product`(IN p_id VARCHAR(36))
BEGIN
    IF NOT EXISTS (SELECT id FROM products WHERE id = p_id) THEN
        SELECT 'not_exist' AS result;
    ELSE
        DELETE FROM products WHERE id = p_id;
        SELECT 'success' AS result;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Delete_user
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_user`(
    IN p_id VARCHAR(36)
)
BEGIN
    DECLARE v_count INT;
    
    SELECT COUNT(*) INTO v_count FROM cart WHERE customer_id = p_id;

    IF v_count != 0 THEN
        DELETE FROM cart WHERE customer_id = p_id;
    END IF;

    SELECT COUNT(*) INTO v_count FROM users WHERE id = p_id;
    
    IF v_count != 0 THEN
        DELETE FROM users WHERE id = p_id;
        SELECT "success";
    ELSE
        SELECT "not_exist";
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Get_cart
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_cart`(IN p_user_id VARCHAR(36))
BEGIN
    SELECT
        cart.product_id, products.name, products.price, cart.quantity,
        (products.price * cart.quantity) AS total
    FROM
        cart
    INNER JOIN
        products
    ON
        cart.product_id = products.id
    WHERE 
        cart.customer_id = p_user_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure List_customers
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `List_customers`()
BEGIN
	SELECT id, full_name, email, user_type, created_at, updated_at
    FROM users
    WHERE user_type = 'customer';
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Login
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Login`(
    IN p_email VARCHAR(150)
)
BEGIN
    SELECT *
    FROM users 
    WHERE email = p_email;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Products_list
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Products_list`()
BEGIN

    SELECT 
        p.id, p.name, p.description, p.price, p.stock, c.name as category, 
        p.created_at, p.updated_at
    FROM 
        products p
    INNER JOIN 
        categories c ON p.category_id = c.id
    ORDER BY 
        p.created_at DESC;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Product_by_id
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Product_by_id`(IN p_id VARCHAR(36))
BEGIN
    SELECT
        p.id, p.name, p.description, p.price, p.stock, c.name as category,
        p.created_at, p.updated_at
    FROM
        products p
    INNER JOIN
        categories c ON p.category_id = c.id
    WHERE
        p.id = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Register
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Register`(
    IN p_id VARCHAR(36),
    IN p_full_name VARCHAR(150),
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(150),
    IN p_phone_number VARCHAR(50),
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE user_count INT;

    SELECT COUNT(*) INTO user_count FROM users WHERE email = p_email;

    IF user_count = 0 THEN
        INSERT INTO users (id, full_name, username, email, phone_number, password, user_type, created_at, updated_at)
        VALUES (p_id, p_full_name, p_username, p_email, p_phone_number, p_password, 'customer', NOW(), NOW());
        SELECT 'success';
    ELSE
        SELECT 'already_exists';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Remove_to_cart
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Remove_to_cart`(
	IN p_user_id VARCHAR(36),
	IN p_product_id VARCHAR(36)
    
)
BEGIN
	IF NOT EXISTS (SELECT id FROM cart WHERE customer_id = p_user_id AND product_id = p_product_id ) THEN
		SELECT 'not_exist';
	ELSE
		DELETE FROM cart WHERE customer_id = p_user_id AND product_id = p_product_id;
        SELECT 'success';
	END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Update_product
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_product`(
    IN p_id VARCHAR(36),
    IN p_name VARCHAR(255),
    IN p_description TEXT,
    IN p_price DECIMAL(10,2),
    IN p_stock INT,
    IN p_category_id VARCHAR(36),
    IN p_category VARCHAR(50)
)
BEGIN
    DECLARE v_category_id VARCHAR(36);
    
    IF NOT EXISTS (SELECT id FROM products WHERE id = p_id) THEN
        SELECT 'not_exist' AS result;
    ELSE
        SELECT id INTO v_category_id FROM categories WHERE name = p_category;
        
        IF v_category_id IS NULL THEN
            INSERT INTO categories (id, name) VALUES (p_category_id, p_category);
            SET v_category_id = p_category_id;
        END IF;
        
        UPDATE products 
        SET 
            name = p_name,
            description = p_description,
            price = p_price,
            stock = p_stock,
            category_id = v_category_id,
            updated_at = NOW()
        WHERE 
            id = p_id;
            
        SELECT 'success';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Update_user
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_user`(
    IN p_id VARCHAR(36),
    IN p_full_name VARCHAR(150),
    IN p_email VARCHAR(150),
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count FROM users WHERE id = p_id;

    IF v_count != 0 THEN
        UPDATE users
        SET full_name = p_full_name, email = p_email, password = p_password, updated_at = NOW()
        WHERE id = p_id;
        SELECT 'success';
    ELSE
        SELECT 'not_exist';
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure User_by_id
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `User_by_id`(IN p_id VARCHAR(36))
BEGIN
	SELECT id, full_name, email, user_type, created_at, updated_at
    FROM users
    WHERE id = p_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure User_list
-- -----------------------------------------------------

DELIMITER $$
USE `ecommerce_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `User_list`()
BEGIN
	SELECT id, full_name, email, user_type, created_at, updated_at
    FROM users
    WHERE user_type = 'customer';
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
