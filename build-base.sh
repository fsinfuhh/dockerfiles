#!/bin/bash

set -e

VERSION=2016.05.02
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
apt install -y vim unattended-upgrades
echo 'unattended-upgrades       unattended-upgrades/enable_auto_updates boolean true' | debconf-set-selections
dpkg-reconfigure -f noninteractive unattended-upgrades
EOF

acbuild set-exec -- /bin/bash
acbuild write --overwrite $IMAGE_NAME
