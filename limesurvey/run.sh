#!/bin/bash
# Ugly, I know...
chown -R www-data /app/upload /var/www/limesurvey/tmp
/usr/sbin/php-fpm7.3 --daemonize --fpm-config /etc/php/7.3/fpm/php-fpm.conf
exec nginx -g 'daemon off;'
