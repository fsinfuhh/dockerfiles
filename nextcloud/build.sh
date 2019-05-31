#! /bin/bash

V=16
VERSION=$(wget -qO- https://download.nextcloud.com/server/releases/ | grep -oE nextcloud-${V}[^\"]\*.tar.bz2 | sort | uniq | tail -1 | cut -d- -f2 | cut -d. -f-3)
NAME=nextcloud

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-buster

acbuild copy-to-dir hotfix-for-share-links-for-logged-in-users.patch /
acbuild run -- /usr/bin/env V=$V /bin/sh -es <<"EOF"
    usermod -u 2002 -g nogroup www-data
    apt-get -y --no-install-recommends install wget php7.3-fpm php7.3 php7.3-gd php7.3-intl php7.3-pgsql php7.3-apcu php7.3-curl php7.3-memcache php7.3-redis php7.3-ldap php7.3-xml php7.3-zip php7.3-json php7.3-mbstring patch gnupg strace bzip2 git php-imagick
    apt-get clean

    mkdir /var/www
    wget -qO- https://download.nextcloud.com/server/releases/latest-${V}.tar.bz2 | tar -C /var/www -xjv --no-same-owner
    cd /var/www/nextcloud
    chown www-data apps
    chown www-data config
   
    cd apps
    git clone https://github.com/nextcloud/richdocuments.git
    cd richdocuments
    git checkout v3.1.1 #TODO: dynamisch rausfinden

    cd ..
    #git clone https://github.com/juliushaertl/theming_customcss.git
    #cd theming_customcss
    #git checkout v1.0.0

    cd ../..

    #patch -p1 < /hotfix-for-share-links-for-logged-in-users.patch
    #sed -i 's/$OC_Channel = '\''stable'\'';/$OC_Channel = '\'''\'';/' version.php
    ln -sf /opt/config/config.php /var/www/nextcloud/config/config.php
    ln -sf /opt/config/www.conf /etc/php/7.3/fpm/pool.d/www.conf
    ln -s /var/log/php7.3-fpm.log /opt/log/php7.3-fpm.error.log

    cat >> /etc/php/7.3/fpm/php.ini <<EOG
opcache.enable=1
opcache.enable_cli=1
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.memory_consumption=128
opcache.save_comments=1
opcache.revalidate_freq=1
EOG

    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
# TODO: this is ugly
cp -r /var/www/nextcloud /opt/static
mkdir /run/php
exec /usr/sbin/php-fpm7.3 --nodaemonize --fpm-config /etc/php/7.3/fpm/php-fpm.conf
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
