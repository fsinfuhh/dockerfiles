#! /bin/bash

VERSION=0.0.1
NAME=python-gunicorn
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci
echo "Building $IMAGE_NAME"

rm -v $IMAGE_NAME

. acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-system
acbuild run -- apt update
acbuild run -- apt install -y python-virtualenv
acbuild run -- virtualenv /opt/py-env
source .acbuild/current/rootfs/opt/py-env/bin/activate 
pip install gunicorn
acbuild port add www tcp 80
#acbuild set-exec -- /usr/sbin/nginx -g "daemon off;"
acbuild write $IMAGE_NAME
sudo -su nils gpg --default-key E4CA7691 --armor --output $IMAGE_NAME.asc --detach-sign $IMAGE_NAME 
