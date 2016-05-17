#! /bin/bash

VERSION=2016.05.17
NAME=gogs
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci

. ../acbuildhelper.sh

echo "Building $IMAGE_NAME"

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-system

acbuild run -- /bin/sh -es <<"EOF"
    adduser --disabled-login --gecos 'Gogs' --uid 2001 --ingroup nogroup gogs
    echo deb http://ftp.de.debian.org/debian jessie-backports main >> /etc/apt/sources.list
    apt update
    apt-get --no-install-recommends -y install golang/jessie-backports golang-go/jessie-backports golang-src/jessie-backports git openssl ca-certificates openssh-client

    su -c 'sh -s' gogs <<"EOG"
    cd
    export GOPATH=$HOME/go
    mkdir go
    go get -u github.com/gogits/gogs
    cd $GOPATH/src/github.com/gogits/gogs
    go build
EOG

    mkdir /opt/gogs
    cp -ra /home/gogs/go/src/github.com/gogits/gogs /opt/gogs
    chown -R root:nogroup /opt/gogs
    mkdir -p /opt/gogs/custom/conf
    ln -sf /opt/config/app.ini /opt/gogs/custom/conf/
    
    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=gogs HOME=/home/gogs
exec /opt/gogs/gogs web
EOG
    chmod +x /usr/local/bin/run

EOF
acbuild port add web tcp 3000
acbuild port add ssh tcp 3001
acbuild mount add storage /opt/storage
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-user -- gogs
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
