#!/bin/bash
set -e
export USER=www-data
export HOME=/home/www-data

# Migrate database and deploy staticfiles
python3 /app/backend/manage.py migrate
python3 /app/backend/manage.py collectstatic --noinput
chown -R www-data:www-data /app/backend/logs

# Start backend with uWSGI
nginx
exec uwsgi /etc/uwsgi/mafiastar.ini
