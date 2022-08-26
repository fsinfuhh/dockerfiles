#!/bin/bash
# Ugly, I know...
chown -R www-data /app/upload /var/www/limesurvey/tmp
/usr/sbin/php-fpm7.4 --daemonize --fpm-config /etc/php/7.4/fpm/php-fpm.conf
exec nginx -g 'daemon off;'
