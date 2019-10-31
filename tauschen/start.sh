#!/bin/bash
set -e
export USER=www-data
export HOME=/home/www-data

# Migrate database and deploy staticfiles
/opt/tauschen/tauschen-backend/manage.py migrate
/opt/tauschen/tauschen-backend/manage.py collectstatic --noinput

# Deploy frontend
cp -rT /opt/tauschen/tauschen-frontend/dist/tauschen-frontend /opt/static/tauschen-frontend

# Start backend with uWSGI
exec uwsgi /etc/uwsgi/tauschen.ini

