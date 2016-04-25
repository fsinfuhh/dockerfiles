#! /bin/bash

set -e

VERSION=2016.04.20
NAME=gogs
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci

. acbuildhelper.sh

echo "Building $IMAGE_NAME"

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-system

acbuild run -- sh -es <<EOF
    adduser --disabled-login --gecos 'Gogs' gogs
    echo deb http://ftp.de.debian.org/debian jessie-backports main >> /etc/apt/sources.list
    apt update
    apt-get --no-install-recommends -y install golang/jessie-backports git openssl ca-certificates
    su - gogs
    export GOPATH=~/go
    mkdir go
    go get -u github.com/gogits/gogs
    cd $GOPATH/src/github.com/gogits/gogs
    go build
    
EOF
acbuild port add web tcp 3000
acbuild port add ssh tcp 22
acbuild set-exec -- /home/gogs/go/src/github.com/gogits/gogs/gogs web

acbuild write --overwrite $IMAGE_NAME
