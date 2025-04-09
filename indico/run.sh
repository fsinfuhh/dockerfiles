#!/bin/bash
set -e
set -x

mkdir -p /app/log/nginx
nginx

indico db upgrade
indico db --all-plugins upgrade

# run worker as nobody
indico celery worker --uid 65534 &

exec uwsgi -i /etc/uwsgi/apps-enabled/indico.ini
