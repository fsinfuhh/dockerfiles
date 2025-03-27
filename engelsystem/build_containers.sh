#!/bin/sh
set -e
set +x

D=$(realpath $(dirname $0))

podman build "$D/engelsystem" -f "$D/engelsystem/docker/Dockerfile" -t git.mafiasi.de/server-ag/dockerfiles/engelsystem

