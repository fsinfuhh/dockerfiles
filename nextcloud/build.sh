#! /bin/bash

V=12
VERSION=$(wget -qO- https://download.nextcloud.com/server/releases/ | grep -oE nextcloud-${V}[^\"]\*.tar.bz2 | sort | uniq | tail -1 | cut -d- -f2 | cut -d. -f-3)
NAME=nextcloud

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-stretch

acbuild copy-to-dir hotfix-for-share-links-for-logged-in-users.patch /
acbuild run -- /usr/bin/env V=$V /bin/sh -es <<"EOF"
    usermod -u 2002 -g nogroup www-data
    apt-get -y --no-install-recommends install wget php7.0-fpm php7.0 php7.0-gd php7.0-intl php7.0-mcrypt php7.0-pgsql php7.0-apcu php7.0-curl php7.0-memcache php7.0-redis php7.0-ldap php7.0-xml php7.0-zip php7.0-json php7.0-mbstring patch gnupg strace bzip2
    apt-get clean

    mkdir /var/www
    wget -qO- https://download.nextcloud.com/server/releases/latest-${V}.tar.bz2 | tar -C /var/www -xjv --no-same-owner
    cd /var/www/nextcloud
    patch -p1 < /hotfix-for-share-links-for-logged-in-users.patch
    sed -i 's/$OC_Channel = '\''stable'\'';/$OC_Channel = '\''foo'\'';/' version.php
    ln -sf /opt/config/config.php /var/www/nextcloud/config/config.php
    ln -sf /opt/config/www.conf /etc/php/7.0/fpm/pool.d/www.conf
    ln -s /var/log/php7.0-fpm.log /opt/log/php7.0-fpm.error.log


    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
# TODO: this is ugly
cp -r /var/www/nextcloud /opt/static
mkdir /run/php
exec /usr/sbin/php-fpm7.0 --nodaemonize --fpm-config /etc/php/7.0/fpm/php-fpm.conf
EOG
    chmod +x /usr/local/bin/run

EOF
echo '{ "set": ["@rkt/default-whitelist"], "errno": "ENOSYS"}' | acbuild isolator add "os/linux/seccomp-retain-set" -
acbuild port add http tcp 9787
acbuild mount add storage /opt/storage
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild mount add static /opt/static
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
