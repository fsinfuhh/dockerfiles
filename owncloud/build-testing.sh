#! /bin/bash

V=9.1
VERSION=$(wget -qO- https://download.owncloud.org/download/repositories/$V/Debian_8.0/Packages  | grep -FxA1 "Package: owncloud" | grep -oE "[0-9]+((-|\.|~)[0-9rc]+)*")
NAME=owncloud-testing

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-testing

acbuild copy-to-dir avatar-relocate.patch /
acbuild copy-to-dir hidden-files-hide-content.patch /
acbuild copy-to-dir hotfix-for-share-links-for-logged-in-users.patch /
acbuild run -- /usr/bin/env V=$V /bin/sh -es <<"EOF"
    usermod -u 2002 -g nogroup www-data
    apt-get -y --no-install-recommends install wget php7.0-fpm php7.0 php7.0-gd php7.0-intl php7.0-mcrypt php7.0-pgsql php7.0-apcu php7.0-curl php7.0-memcache php7.0-redis php7.0-ldap php7.0-xml php7.0-zip php7.0-json php7.0-mbstring patch gnupg strace

    wget -nv https://download.owncloud.org/download/repositories/$V/Debian_8.0/Release.key -O- | apt-key add -
    echo deb http://download.owncloud.org/download/repositories/$V/Debian_8.0/ / > /etc/apt/sources.list.d/owncloud.list
    apt update
    apt -y install owncloud-files
    apt-get clean
    cd /var/www/owncloud
    patch -p1 < /hotfix-for-share-links-for-logged-in-users.patch
    ls -al /etc/php*
    ln -sf /opt/config/config.php /var/www/owncloud/config/config.php
    ln -sf /opt/config/www.conf /etc/php/7.0/fpm/pool.d/www.conf
    ln -s /var/log/php7.0-fpm.log /opt/log/php7.0-fpm.error.log


    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
# TODO: this is ugly
cp -r /var/www/owncloud /opt/static
mkdir /run/php
exec /usr/sbin/php-fpm7.0 --nodaemonize --fpm-config /etc/php/7.0/fpm/php-fpm.conf
EOG
    chmod +x /usr/local/bin/run

EOF
#acbuild copy uwsgi-owncloud.ini /etc/uwsgi/owncloud.ini
echo '{ "set": ["@rkt/default-whitelist"], "errno": "ENOSYS"}' | acbuild isolator add "os/linux/seccomp-retain-set" -
acbuild port add http tcp 9787
acbuild mount add storage /opt/storage
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild mount add static /opt/static
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
