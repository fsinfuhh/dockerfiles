#!/bin/sh
set -e
set +x

D=$(realpath $(dirname $0))

podman build "$D/engelsystem" -f "$D/engelsystem/docker/Dockerfile" -t registry.mafiasi.de/engelsystem-php
podman build "$D/engelsystem" -f "$D/engelsystem/docker/nginx/Dockerfile" -t registry.mafiasi.de/engelsystem-nginx

