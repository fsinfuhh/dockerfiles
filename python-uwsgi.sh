#! /bin/bash

set -e

VERSION=0.0.1
NAME=python-uwsgi
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci

. acbuildhelper.sh

echo "Building $IMAGE_NAME"

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-system

acbuild run -- sh -es <<EOF
    apt update
    apt install -y uwsgi python-virtualenv
    virtualenv --system-site-packages /opt/py-env

    cat <<XXX > /opt/uwsgi.defaults.conf
    [uwsgi]
    socket=127.0.0.1:3031
    processes=4
    master=true
    threads=2
    stats=127.0.0.1:9191
    virtualenv=/opt/py-env/
    #ini=/opt/uwsgi.app.conf
    XXX
EOF
acbuild port add uwsgi tcp 3031
acbuild port add stats tcp 9191
acbuild set-exec -- /usr/bin/uwsgi /opt/uwsgi.defaults.conf

acbuild write --overwrite $IMAGE_NAME
