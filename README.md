# Dockerfile para la API Flask
FROM python:3.9

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000
CMD ["python", "app.py"]

# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    depends_on:
      - db
    networks:
      - app_network

  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: flaskdb
      MYSQL_USER: user
      MYSQL_PASSWORD: password
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - app_network

  nginx:
    image: nginx:latest
    ports:
      - "3232:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - web
    networks:
      - app_network

networks:
  app_network:
    driver: bridge

volumes:
  mysql_data:

# nginx.conf
events {}

http {
    upstream flask_api {
        server web:5000;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://flask_api;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}

# app.py
from flask import Flask, jsonify
import mysql.connector

app = Flask(__name__)

def get_message():
    connection = mysql.connector.connect(
        host="db",
        user="user",
        password="password",
        database="flaskdb"
    )
    cursor = connection.cursor()
    cursor.execute("SELECT message FROM messages LIMIT 1;")
    message = cursor.fetchone()
    cursor.close()
    connection.close()
    return message[0] if message else "Hola mundo"

@app.route('/')
def hello_world():
    return jsonify({"message": get_message()})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

# README.md
# Proyecto Flask con Docker, MySQL y NGINX

Este proyecto implementa una API REST con Flask que interactúa con MySQL y es gestionada por NGINX usando Docker y Docker Compose.

## Requisitos
- Docker
- Docker Compose

## Instalación y ejecución
1. Clonar el repositorio:
   ```sh
   git clone https://github.com/javiburn/docker-compose-flask-api.git
   ```
2. Crear un archivo `requirements.txt` con las dependencias necesarias:
   ```sh
   flask
   mysql-connector-python
   ```
3. Construir y ejecutar los contenedores:
   ```sh
   docker-compose up --build
   ```

## Acceso a la API
- La API estará disponible en: [http://localhost:3232](http://localhost:3232)
- Endpoint principal:
  ```sh
  curl http://localhost:3232/
  ```
  Respuesta esperada:
  ```json
  {"message": "Hola mundo"}
  ```

## Estructura del proyecto
```
.
├── app.py              # Código de la API Flask
├── docker-compose.yml  # Configuración de Docker Compose
├── Dockerfile          # Imagen de la API Flask
├── nginx.conf          # Configuración de NGINX
├── requirements.txt    # Dependencias de Python
└── README.md           # Documentación del proyecto
```

## Notas
- Se ha configurado un volumen para MySQL (`mysql_data`) para mantener la persistencia de datos.
- `nginx` actúa como proxy inverso y redirige las solicitudes HTTP a la API Flask.

## Detener los contenedores
```sh
docker-compose down
```
