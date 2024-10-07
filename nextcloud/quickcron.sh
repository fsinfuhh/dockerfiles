#!/usr/bin/env sh
set -e

echo "Preparing environment"
cp /opt/config/config.php /var/www/nextcloud/config/config.php
chown -R www-data /var/www/nextcloud/config /var/www/nextcloud/apps /opt/log
chmod +x /var/www/nextcloud/occ
mkdir -p /run/php
export USER=www-data HOME=/home/www-data

echo "Running cron.php"
su -s /usr/bin/php www-data /var/www/nextcloud/cron.php

