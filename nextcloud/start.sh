#!/bin/sh
cp /opt/config/config.php /var/www/nextcloud/config/config.php
chown -R www-data /var/www/nextcloud/config /opt/log

nginx

export USER=www-data HOME=/home/www-data
mkdir /run/php
exec /usr/sbin/php-fpm7.4 --nodaemonize --fpm-config /etc/php/7.4/fpm/php-fpm.conf
