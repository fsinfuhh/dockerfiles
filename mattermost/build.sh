#! /bin/bash

VERSION=3.9.0
NAME=mattermost

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base

acbuild run -- /usr/bin/env VERSION=$VERSION /bin/sh -es <<"EOF"
    usermod -u 2003 -g nogroup www-data
    apt-get -y --no-install-recommends install wget
    wget -nv https://releases.mattermost.com/$VERSION/mattermost-team-$VERSION-linux-amd64.tar.gz -O- | tar -C /opt -xz
    sed -i 's/"login.gitlab":"GitLab"/"login.gitlab":"Login"/' /opt/mattermost/webapp/dist/main.*.js
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
