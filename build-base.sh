#!/bin/bash

set -e

VERSION=2016.04.20
NAME=base-system
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci

. acbuildhelper.sh

echo "Building $IMAGE_NAME"
acbuild set-name rkt.mafiasi.de/$NAME
debootstrap --variant=minbase jessie .acbuild/currentaci/rootfs http://ftp.de.debian.org/debian/

acbuild run -- sh <<EOF
echo deb http://security.debian.org/ jessie/updates main >> /etc/apt/sources.list
apt update
apt upgrade -y
apt install -y vim
EOF

acbuild write --overwrite $IMAGE_NAME
