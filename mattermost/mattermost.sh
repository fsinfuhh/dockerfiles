#! /bin/bash

VERSION=2016.05.24
NAME=mattermost
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci

. ../acbuildhelper.sh

echo "Building $IMAGE_NAME"

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-system

acbuild run -- /bin/sh -es <<"EOF"
    usermod -u 2003 -g nogroup www-data
    apt-get -y --no-install-recommends install wget
    wget -nv https://releases.mattermost.com/3.2.0/mattermost-team-3.2.0-linux-amd64.tar.gz -O- | tar -C /opt -xz
    chown -R www-data:nogroup /opt/mattermost

    ln -sf /opt/config/config.json /opt/mattermost/config/config.json
    rmdir /opt/mattermost/logs
    ln -sf /opt/log /opt/mattermost/logs

    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
cd /opt/mattermost
exec /opt/mattermost/bin/platform
EOG
    chmod +x /usr/local/bin/run

EOF
acbuild port add www tcp 8065
acbuild mount add storage /opt/storage
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
