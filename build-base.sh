#!/bin/bash

set -e

VERSION=0.0.2
NAME=base-system
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci

. acbuildhelper.sh

echo "Building $IMAGE_NAME"
acbuild set-name rkt.mafiasi.de/$NAME
debootstrap --variant=minbase jessie .acbuild/currentaci/rootfs http://ftp.de.debian.org/debian/

acbuild run -- apt update
acbuild run -- apt install -y vim-tiny

acbuild write --overwrite $IMAGE_NAME
