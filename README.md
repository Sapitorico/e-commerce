# Ecommerce

API de backend diseñada para gestionar un sistema de comercio electrónico. Proporciona endpoints para manejar productos, clientes, administradores.

## Tabla de Contenidos

- [Descripción](#descripción)
- [Características](#características)
- [Prerrequisitos](#prerrequisitos)
- [Instalación](#instalación)
- [Uso](#uso)
- [Tecnologías Utilizadas](#tecnologías-utilizadas)
- [Patrones de Diseño](#patrones-de-diseño)

## Descripción

Es una API de backend que se utiliza en sistemas de comercio electrónico. Proporciona funcionalidades que permiten a los administradores administrar de manera eficiente productos, categorías, precios, inventario y usuarios. Permite a los usuarios interactuar con la plataforma al agregar y quitar artículos de su carrito de compras de forma fácil y segura, e incluye la funcionalidad para realizar pagos de los productos en el carrito de compras.

## Características

### Control de Usuarios y Roles

Se implementa un sistema de gestión de usuarios y roles para garantizar la seguridad y el control de acceso a las funcionalidades de la API. Las capacidades incluyen:

- Crear cuentas de cliente para permitir la interacción con la plataforma.
- Asignar roles específicos a los usuarios para controlar su acceso a funciones específicas.

### Medidas de Seguridad

La API implementa una serie de medidas de seguridad para proteger los datos y garantizar el control de acceso adecuado. Estas medidas incluyen:

- **Autenticación de Usuarios:** Utilización de tokens JWT (JSON Web Tokens) para autenticar a los usuarios y garantizar la seguridad de las sesiones.
- **Autorización Basada en Roles:** Restricción de acceso a funcionalidades específicas basadas en los roles asignados a los usuarios.
- **Validación de Datos:** Implementación de validación de datos para prevenir ataques de inyección de código y garantizar la integridad de los datos.

### Administradores

Los administradores tienen la capacidad de realizar las siguientes acciones:

- **Gestión de Productos:**
  - Crear, actualizar y eliminar productos, incluyendo detalles como nombre, descripción, precio y categoría.
  - Gestionar el stock de productos para garantizar la disponibilidad adecuada.
  - Actualizar categorías y nombres; se crean nuevas categorías cuando se asigna un producto a una categoría no existente.
  
- **Control de Usuarios:**
  - Visualizar y gestionar todos los clientes existentes en la plataforma.
  - Actualizar su propio perfil, incluyendo información personal.

### Clientes

Los clientes tienen la capacidad de realizar las siguientes acciones:

- **Visualización de Productos:**
  - Ver los productos disponibles en la plataforma, incluyendo detalles como precios, descripciones y categorías.
  
- **Perfil de Usuario:**
  - Actualizar su propio perfil, incluyendo información personal, direcciones y detalles de contacto.
  - Administrar sus direcciones de envío y facturación.

- **Carrito de Compras:**
  - Agregar, eliminar y actualizar productos en el carrito, incluyendo la cantidad deseada.
  - Ver el contenido actualizado de su carrito antes de proceder con la compra.
  - Realizar el pago de los productos en su carrito.

### Login y Registro

Se proporcionan endpoints para el registro y autenticación de usuarios en la plataforma, utilizando un sistema seguro basado en tokens JWT.

## Prerrequisitos

Antes de comenzar, asegúrate de tener instalados los siguientes requisitos en tu sistema Ubuntu:

- **Docker:** Puedes seguir la [documentación oficial de Docker](https://docs.docker.com/engine/install/ubuntu/) para instalar Docker en Ubuntu si deseas ejecutar el proyecto en un contenedor.
- **Python:** Puedes seguir la [documentación oficial de Python](https://www.python.org/downloads/) para instalar Python en Ubuntu si deseas ejecutar el proyecto de forma nativa.
- **Virtualenv:** Puedes instalarlo utilizando pip si optas por ejecutar el proyecto de forma nativa:

   ```bash
   pip install virtualenv
   ```

- **MySQL:** Puedes instalar MySQL utilizando los siguientes comandos:

  ```bash
  sudo apt update
  sudo apt install mysql-server
  ```

  Una vez instalado MySQL, puedes iniciar el servicio con:

  ```bash
  sudo service mysql start
  ```

## Configuración de Entorno (.env)

Asegúrate de crear un archivo `.env` en el directorio raíz del proyecto con la siguiente configuración:

```dotenv
# Flask configuration
FLASK_APP=main.py

# API config
BASE_URL=          # URL base de la API

# MySQL configuration
MYSQL_HOST=        # Dirección del host de la base de datos MySQL
MYSQL_PORT=        # Puerto de la base de datos MySQL
MYSQL_USER=        # Usuario de la base de datos MySQL
MYSQL_PASSWORD=    # Contraseña del usuario de la base de datos MySQL
MYSQL_DB=          # Nombre de la base de datos MySQL

# JWT Secret
JWT_SECRET=        # Clave secreta para tokens JWT

# Mercado pago
MP_ACCESS_TOKEN=   # Token de acceso de Mercado Pago
```

## Instalación

### Utilizando Docker

1. Construye la imagen Docker ejecutando el siguiente comando en el directorio del proyecto:

    ```bash
    docker build -t ecommerce-app .
    ```

   Este comando construirá la imagen Docker utilizando el Dockerfile presente en el directorio actual y la etiquetará como `ecommerce-app`.

2. Una vez que la imagen se haya construido correctamente, puedes ejecutar el contenedor Docker utilizando el siguiente comando:

    ```bash
    docker run -d -p 8000:8000 ecommerce-app
    ```

### Ejecución Local

Para ejecutar el proyecto localmente, sigue estos pasos:

1. Clona este repositorio en tu máquina local:

   ```bash
   git clone https://github.com/Sapitorico/e-commerce

   cd e-commerce
   ```

2. Crea y activa un entorno virtual:

    ```bash
    python -m venv venv

    source venv/bin/activate
    ```

3. Instala las dependencias del proyecto:

    ```bash
    pip install -r requirements.txt
    ```

4. Ejecuta la aplicación:

    ```bash
    python main.py
    ```

## Uso

Para utilizar la API, utiliza la URL base `/api` seguida de las siguientes rutas. La identificación del usuario se realiza mediante el token de sesión, que debe ser proporcionado en los encabezados de la solicitud.

- **Registro de Usuario**
  - **Método HTTP:** POST
  - **Endpoint:** `/auth/register`
  - **Descripción:** Este endpoint permite que un usuario se registre.
  - **Ejemplo de Cuerpo de la Solicitud (JSON):**

     ```json
     {
       "full_name": "Nombre Usuario",
       "username": "Username",
       "email": "example@example.com",
       "phone_number": "Numero de telefono",
       "password": "password123"
     }
     ```

- **Inicio de Sesión de Usuario**
  - **Método HTTP:** POST
  - **Endpoint:** `/auth/login`
  - **Descripción:** Este endpoint permite que un usuario inicie sesión
  - **Ejemplo de Cuerpo de la Solicitud (JSON):**

     ```json
     {
       "email": "example@example.com",
       "password": "password123"
     }
     ```

- **Ver Perfil del Usuario (requiere token de sesión admin)**
  - **Método HTTP:** GET
  - **Endpoint:** `/users`
  - **Descripción:** Este endpoint permite ver todos los customers.

- **Ver Perfil del Usuario (requiere token de sesión)**
  - **Método HTTP:** GET
  - **Endpoint:** `/users/profile`
  - **Descripción:** Este endpoint permite ver el perfil del usuario actual.

- **Actualizar Información del Usuario (requiere token de sesión)**
  - **Método HTTP:** PUT
  - **Endpoint:** `/users/update`
  - **Descripción:** Este endpoint permite actualizar la información del usuario actual.
  - **Ejemplo de Cuerpo de la Solicitud (JSON):**

     ```json
     {
       "email": "nuevo_email@example.com",
       "full_name": "Nuevo Nombre Usuario",
       "username": "nuevo username",
       "phone_number": "nuevo numero de telefono",
       "password": "nueva_contraseña123"
     }
     ```

- **Eliminar Usuario (requiere token de sesión)**
  - **Método HTTP:** DELETE
  - **Endpoint:** `/users/delete`
  - **Descripción:** Este endpoint permite eliminar la cuenta del usuario actual.

- **Agregar Dirección al Usuario (requiere token de sesión)**
  - **Método HTTP:** POST
  - **Endpoint:** `/address/add`
  - **Descripción:** Este endpoint permite agregar una nueva dirección al perfil del usuario actual.
  - **Ejemplo de Cuerpo de la Solicitud (JSON):**

    ```json
    {
      "state": "California",
      "city": "Los Angeles",
      "address": "123 Fake Street"
    }
    ```

- **Ver Direcciónes del Usuario (requiere token de sesión)**
  - **Método HTTP:** GET
  - **Endpoint:** `/address`
  - **Descripción:** Este endpoint permite ver las direcciones asociadas al perfil del usuario actual.

- **Ver Direccióne Espesifica del Usuario (requiere token de sesión)**
  - **Método HTTP:** GET
  - **Endpoint:** `/address/{address_id}`
  - **Descripción:** Este endpoint permite ver una direccion asociada al perfil del usuario actual.

- **Actualizar Dirección (requiere token de sesión)**
  - **Método HTTP:** PUT
  - **Endpoint:** `/address/update/{address_id}`
  - **Descripción:** Este endpoint permite actualizar la informacio de una dirección asociada al perfil del usuario actual.
  - **Ejemplo de Cuerpo de la Solicitud (JSON):**

    ```json
    {
      "department": "Department",
      "locality": "Locality",
      "street_address": "street address",
      "number": "number",
      "type": "home", //home or work
      "additional_references": "additional references"
    }
    ```

- **Eliminar Dirección (requiere token de sesión)**
  - **Método HTTP:** DELETE
  - **Endpoint:** `/address/delete/{address_id}`
  - **Descripción:** Este endpoint permite eliminar una direccion asociada al perfil del usuario actual.

- **Crear Producto (requiere token de sesión admin)**
  - **Método HTTP:** POST
  - **Endpoint:** `/products/create`
  - **Descripción:** Este endpoint permite crear un nuevo producto.
  - **Ejemplo de Cuerpo de la Solicitud (JSON):**

    ```json
    {
      "name": "Zapatillas deportivas",
      "description": "Zapatillas cómodas y ligeras para actividades deportivas",
      "price": 59.99,
      "stock": 100,
      "category": "Calzado"
    }
    ```

- **Ver Todos los Productos**
  - **Método HTTP:** GET
  - **Endpoint:** `/products`
  - **Descripción:** Este endpoint permite ver todos los productos disponibles.

- **Ver Producto Específico**
  - **Método HTTP:** GET
  - **Endpoint:** `/products/{product_id}`
  - **Descripción:** Este endpoint permite ver un producto específico proporcionando su ID.

- **Actualizar Producto (requiere token de sesión admin)**
  - **Método HTTP:** PUT
  - **Endpoint:** `/products/update/{product_id}`
  - **Descripción:** Este endpoint permite actualizar un producto específico proporcionando su ID y los datos actualizados.
  - **Ejemplo de Cuerpo de la Solicitud (JSON):**

    ```json
    {
      "name": "Zapatillas deportivas",
      "description": "Zapatillas cómodas y ligeras para actividades deportivas",
      "price": 29.99,
      "stock": 100,
      "category": "Calzado"
    }
    ```

- **Eliminar Producto (requiere token de sesión admin)**
  - **Método HTTP:** DELETE
  - **Endpoint:** `/products/delete/{id}`
  - **Descripción:** Este endpoint permite eliminar un producto específico proporcionando su ID.

- **Agregar Producto al Carrito (requiere token de sesión)**
  - **Método HTTP:** POST
  - **Endpoint:** `/cart/add`
  - **Descripción:** Este endpoint permite agregar un producto al carrito
  - **Ejemplo de Cuerpo de la Solicitud (JSON):**

    ```json
    {
      "product_id": "bac24cb7-982e-4586-9b9a-1fa29595a23d",
      "quantity": 4
    }
    ```

- **Ver Carrito (requiere token de sesión)**
  - **Método HTTP:** GET
  - **Endpoint:** `/cart`
  - **Descripción:** Este endpoint permite ver el contenido actual del carrito.

- **Eliminar Producto del Carrito (requiere token de sesión)**
  - **Método HTTP:** DELETE
  - **Endpoint:** `/cart/remove/{product_id}`
  - **Descripción:** Este endpoint permite eliminar una unidad del producto especificado del carrito.

- **Generar link de pago (requiere token de sesión)**
  - **Método HTTP:** GET
  - **Endpoint:** `/payment/generate/{address_id}`
  - **Descripción:** Este endpoint permite generar un link de pago. Para usar este endpoint, el usuario debe tener un token de sesión válido y debe haber productos en el carrito.

## Tecnologías Utilizadas

- **Framework:** Flask
- **Base de Datos:** MySQL

## Patrones de Diseño

- **Modelo-Vista-Controlador (MVC)**
- **Singleton**
