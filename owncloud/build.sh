#! /bin/bash

V=8.2
VERSION=$(wget -qO- https://download.owncloud.org/download/repositories/$V/Debian_8.0/Packages  | grep -FxA1 "Package: owncloud" | grep -oE "[0-9]+((-|\.)[0-9]+)*")
NAME=owncloud

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base

acbuild run -- /usr/bin/env V=$V /bin/sh -es <<"EOF"
    usermod -u 2002 -g nogroup www-data
    apt-get -y --no-install-recommends install wget php5-fpm php5 php5-gd php5-intl php5-mcrypt php5-pgsql php5-apcu php5-curl php5-memcache php5-redis php5-ldap

    wget -nv https://download.owncloud.org/download/repositories/$V/Debian_8.0/Release.key -O- | apt-key add -
    echo deb http://download.owncloud.org/download/repositories/$V/Debian_8.0/ / > /etc/apt/sources.list.d/owncloud.list
    apt update
    apt -y install owncloud-files
    apt-get clean

    ln -sf /opt/config/config.php /var/www/owncloud/config/config.php
    ln -sf /opt/config/www.conf /etc/php5/fpm/pool.d/www.conf
    ln -s /var/log/php5-fpm.log /opt/log/php5-fpm.error.log


    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
# TODO: this is ugly
cp -r /var/www/owncloud /opt/static
exec /usr/sbin/php5-fpm --nodaemonize --fpm-config /etc/php5/fpm/php-fpm.conf
EOG
    chmod +x /usr/local/bin/run

EOF
#acbuild copy uwsgi-owncloud.ini /etc/uwsgi/owncloud.ini
acbuild port add http tcp 9787
acbuild mount add storage /opt/storage
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild mount add static /opt/static
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
