#! /bin/bash

VERSION=0.0.1
NAME=base-system
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci
echo "Building $IMAGE_NAME"

rm -v $IMAGE_NAME

. acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
debootstrap --variant=minbase jessie .acbuild/currentaci/rootfs http://ftp.de.debian.org/debian/

acbuild run -- apt update
acbuild run -- apt install -y vim

acbuild write $IMAGE_NAME
sudo -su nils gpg --default-key E4CA7691 --armor --output $IMAGE_NAME.asc --detach-sign $IMAGE_NAME 
