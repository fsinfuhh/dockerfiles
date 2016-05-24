#! /bin/bash

VERSION=2016.05.24
NAME=owncloud
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci

. ../acbuildhelper.sh

echo "Building $IMAGE_NAME"

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-system

acbuild run -- /bin/sh -es <<"EOF"
    usermod -u 2002 -g nogroup www-data
    apt-get -y --no-install-recommends install wget uwsgi uwsgi-plugin-php php5 php5-gd php5-intl php5-mcrypt php5-pgsql php5-apcu php5-curl php5-memcache php5-redis php5-ldap

    wget -nv https://download.owncloud.org/download/repositories/8.2/Debian_8.0/Release.key -O- | apt-key add -
    echo 'deb http://download.owncloud.org/download/repositories/8.2/Debian_8.0/ /' > /etc/apt/sources.list.d/owncloud.list
    apt update
    apt -y install owncloud-files
    apt-get clean

    ln -sf /opt/config/config.php /var/www/owncloud/config/config.php

    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
exec uwsgi /etc/uwsgi/owncloud.ini
EOG
    chmod +x /usr/local/bin/run

EOF
acbuild copy uwsgi-owncloud.ini /etc/uwsgi/owncloud.ini
acbuild port add uwsgi tcp 9787
acbuild mount add storage /opt/storage
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
