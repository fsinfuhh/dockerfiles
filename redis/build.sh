#! /bin/bash

NAME=redis

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-buster

acbuild run -- /bin/sh -es <<"EOF"
    apt-get -y --no-install-recommends install redis-server
    apt-get clean
    service redis-server stop
    usermod -u 2003 -g nogroup redis
    chown -R redis:nogroup /var/log/redis
    chown -R redis /etc/redis
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
