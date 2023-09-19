#!/bin/bash
# Ugly, I know...
chown -R www-data /app/upload /var/www/limesurvey/tmp
/usr/sbin/php-fpm8.2 --daemonize --fpm-config /etc/php/8.2/fpm/php-fpm.conf
exec nginx -g 'daemon off;'
