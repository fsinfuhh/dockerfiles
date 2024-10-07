#!/usr/bin/env sh
set -e

echo "Preparing environment"
cp /opt/config/config.php /var/www/nextcloud/config/config.php
chown -R www-data /var/www/nextcloud/config /var/www/nextcloud/apps /opt/log
chmod +x /var/www/nextcloud/occ
mkdir -p /run/php
export USER=www-data HOME=/home/www-data

echo "Syncing system address books with dav"
su -s /var/www/nextcloud/occ www-data -- dav:sync-system-addressbook

echo "Running cron.php"
su -s /usr/bin/php www-data /var/www/nextcloud/cron.php

echo "Add missing db indices"
su -s /var/www/nextcloud/occ www-data -- db:add-missing-indices

echo "Running expensive maintenance repair tasks"
su -s /var/www/nextcloud/occ www-data -- maintenance:repair --include-expensive

