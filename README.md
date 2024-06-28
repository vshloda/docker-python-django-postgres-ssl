
## Environment Setup for the Latest Version of Django (Python, Nginx, Postgres) Using Docker

### Project Structure

- `docker` - Folder for Docker configuration files
- `src` - Folder where the project code will be stored
- `.env` - Configuration values for the project

### Step-by-Step Guide

#### 1. Environment Setup

- Create a `.env` file based on `.env.example` using the following command:

  ```sh
  cp .env.example .env

- Enter or leave the default port values for your project:


    DOCKER_HTTP_PORT=80
    NGINX_CONF_PATH=./docker/nginx/conf.d  # Path to the nginx configuration file,
                                          # leave as is for the development environment

- Fill in the database values:

  
    DB_USER
    DB_PASSWORD
    DB_DATABASE
    DB_HOST
    DB_PORT

#### 2. Build the Project Using Docker Compose

    docker compose build

#### 3. Create a Django Project

-  Create a Django project where the project name is project (if you change the project name, update the DJANGO_PROJECT_NAME in the .env file):


  docker compose run --rm web django-admin startproject project .


- After running this command, the project code should appear in the src folder.

- You can verify if the project is working by opening the browser and adding the port specified in DOCKER_HTTP_PORT. For example, if it’s set to 80:

http://localhost


#### 4. Configure Django 

- Import the os library for environment variable handling in settings.py located in the project folder /src/project:
   
   import os


- Add STATIC_ROOT in settings.py:


    STATIC_ROOT = os.path.join(BASE_DIR, 'static')

- Configure Postgres in settings.py:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql',
            'HOST': os.environ.get('DB_HOST'),
            'PORT': os.environ.get('DB_PORT'),
            'NAME': os.environ.get('DB_DATABASE'),
            'USER': os.environ.get('DB_USER'),
            'PASSWORD': os.environ.get('DB_PASSWORD'),
        }
    }

#### 5. Run Migrations

    docker compose run --rm web python manage.py migrate

- After running this command, you can access the admin panel at:

    http://localhost/admin


#### 6. Handle Static Files

- Uncomment the lines for the ENTRYPOINT in the python.Dockerfile, which runs the command for static files:


    COPY ./docker/entrypoint.sh /entrypoint.sh
    RUN chmod +x /entrypoint.sh

    ENTRYPOINT ["/entrypoint.sh"]

- Then, restart Docker:

    docker compose restart web

- Alternatively, you can run the following command:

    docker compose run --rm web python manage.py collectstatic

