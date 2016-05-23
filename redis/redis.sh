#! /bin/bash

VERSION=2016.05.23
NAME=redis
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci

. ../acbuildhelper.sh

echo "Building $IMAGE_NAME"

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-system

acbuild run -- /bin/sh -es <<"EOF"
    apt-get -y --no-install-recommends install redis-server
    service redis-server stop
    usermod -u 2003 -g nogroup redis
    chown -R redis:nogroup /var/log/redis
    sed -i "s/daemonize yes/daemonize no/g" /etc/redis/redis.conf
    sed -i "s/# bind 127.0.0.1/bind 127.0.0.1/g" /etc/redis/redis.conf
    rm -r /var/lib/redis
    ln -sf /opt/storage/redis /var/lib
EOF
acbuild mount add storage /opt/storage
acbuild set-user -- redis
acbuild set-group -- nogroup
acbuild set-exec -- /usr/bin/redis-server /etc/redis/redis.conf

acbuild write --overwrite $IMAGE_NAME
