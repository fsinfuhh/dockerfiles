#!/bin/bash

VERSION=2016.05.17
NAME=base-system
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci

. acbuildhelper.sh

echo "Building $IMAGE_NAME"
acbuild set-name rkt.mafiasi.de/$NAME
debootstrap --variant=minbase jessie $T/.acbuild/currentaci/rootfs http://ftp.de.debian.org/debian/

acbuild run -- sh -es <<EOF
echo deb http://ftp.de.debian.org/debian jessie-updates main >> /etc/apt/sources.list
echo deb http://security.debian.org/ jessie/updates main >> /etc/apt/sources.list
apt update
apt upgrade -y
apt install -y vim ca-certificates
mkdir /opt/config /opt/storage /opt/log
EOF

acbuild set-exec -- /bin/bash
acbuild write --overwrite $IMAGE_NAME
