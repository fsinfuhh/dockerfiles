#! /bin/bash

VERSION=0.0.1
NAME=python-uwsgi
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci
echo "Building $IMAGE_NAME"

rm -v $IMAGE_NAME

. acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-system
acbuild run -- apt update
acbuild run -- apt install -y python-virtualenv build-essential python-dev
acbuild run -- virtualenv /opt/py-env
read bla
source .acbuild/currentaci/rootfs/opt/py-env/bin/activate 
pip install uwsgi

acbuild port add uwsgi tcp 3031
acbuild port add stats tcp 9191
echo """
[uwsgi]
socket=127.0.0.1:3031
processes=4
master=true
threads=2
stats=127.0.0.1:9191
virtualenv=/opt/py-env/
ini=/opt/uwsgi.app.conf
""" > .acbuild/currentaci/rootfs/opt/uwsgi.defaults.conf
acbuild set-exec -- /opt/py-env/bin/uwsgi /opt/uwsgi.defaults.conf

acbuild write $IMAGE_NAME
sudo -su nils gpg --default-key E4CA7691 --armor --output $IMAGE_NAME.asc --detach-sign $IMAGE_NAME 
