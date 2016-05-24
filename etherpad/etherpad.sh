#! /bin/bash

VERSION=2016.05.24
NAME=etherpad
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci

. ../acbuildhelper.sh

echo "Building $IMAGE_NAME"

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-system

acbuild run -- /bin/sh -es <<"EOF"
    usermod -u 2002 -g nogroup www-data
    apt-get -y --no-install-recommends install wget lsb-release apt-transport-https

    wget -nv https://deb.nodesource.com/gpgkey/nodesource.gpg.key -O- | apt-key add -
    echo 'deb deb https://deb.nodesource.com/node_4.x jessie main' > /etc/apt/sources.list.d/nodejs.list
    apt update
    apt -y install nodejs
    apt-get clean

    wget -nv https://github.com/ether/etherpad-lite/tarball/master -O- | tar -C /opt -xz
    mv /opt/ether-etherpadlite* /opt/etherpad
    chown -R ehterpad:nogroup /opt/etherpad

    ln -sf /opt/config/config.php /var/www/owncloud/config/config.php

    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
cd /opt/etherpad
exec ./bin/run.sh
EOG
    chmod +x /usr/local/bin/run

EOF
acbuild port add www tcp 9001
acbuild mount add storage /opt/storage
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
