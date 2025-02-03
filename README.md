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
