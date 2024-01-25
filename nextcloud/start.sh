#!/bin/sh
cp /opt/config/config.php /var/www/nextcloud/config/config.php
chown -R www-data /var/www/nextcloud/config /var/www/nextcloud/apps /opt/log

nginx

export USER=www-data HOME=/home/www-data
mkdir -p /run/php
exec /usr/sbin/php-fpm8.2 --nodaemonize --fpm-config /etc/php/8.2/fpm/php-fpm.conf
