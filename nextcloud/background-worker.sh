#!/bin/sh
set -e
cp /opt/config/config.php /var/www/nextcloud/config/config.php
chown -R www-data /var/www/nextcloud/config /var/www/nextcloud/apps /opt/log
chmod +x /var/www/nextcloud/occ
export USER=www-data HOME=/home/www-data

exec su -s /var/www/nextcloud/occ www-data background-jobs:worker
