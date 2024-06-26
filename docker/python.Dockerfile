FROM python:3.12-alpine

ENV PYTHONUNBUFFED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN apk upgrade && apk update \
    && apk add gcc python3-dev musl-dev \
    jpeg-dev gettext zlib-dev py3-setuptools \
    mariadb-connector-c-dev mariadb-dev

RUN apk del libressl
RUN apk add openssl
RUN apk fix

#libressl-dev
RUN apk add libffi-dev cargo

RUN mkdir /app
WORKDIR /app
COPY ./src /app

COPY ./requirements.txt /app/requirements.txt
# Install any required dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Collect static files
# RUN python manage.py collectstatic

# Expose port 8000 for Gunicorn
EXPOSE 8000