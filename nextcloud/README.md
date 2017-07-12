% nextcloud

UID: 2002

Ports:
- uwsgi

Mountpoints:
- config
- storage
- log


Initial steps:
```sh
mkdir -p /opt/config/nextcloud /var/log/nextcloud /srv/nextcloud /srv/nextcloud/redis
cp $CONFIG_DIR/config.php /opt/config/config.php
chown 2002:nogroup /opt/config/nextcloud /opt/config/nextcloud/config.php /var/log/nextcloud /srv/nextcloud
chown 2003:nogroup /srv/nextcloud/redis
rkt run [...] rkt.mafiasi.de/nextcloud  rkt.mafiasi.de/redis
rkt enter --app=nextcloud rkt-$UUID /bin/bash
# run /var/www/nextcloud/occ maintenance:install [...]
```

How to run:
```sh
rkt run --port=uwsgi:9787 --volume storage,kind=host,source=/srv/nextcloud --volume config,kind=host,source=/opt/config/nextcloud --volume log,kind=host,source=/var/log/nextcloud --dns=134.100.9.61 rkt.mafiasi.de/nextcloud rkt.mafiasi.de/redis
```
