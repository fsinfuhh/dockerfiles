#!/usr/bin/env bash
set -e

mkdir -p /app/storage
python3 /app/src/manage.py migrate

