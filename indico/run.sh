#!/bin/bash
set -e
set -x

mkdir -p /app/log/nginx
nginx

# Ignore indico db upgrade failures for now -- this should not stay this way!

indico db upgrade || true
indico db --all-plugins upgrade

# run worker as nobody
indico celery worker --uid 65534 &

exec uwsgi -i /etc/uwsgi/apps-enabled/indico.ini
