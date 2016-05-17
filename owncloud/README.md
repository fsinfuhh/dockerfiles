% Owncloud

UID: 2002

Ports:
- uwsgi

Mountpoints:
- config
- storage
- log


Initial steps:
```sh
mkdir -p /opt/config/owncloud /var/log/owncloud /srv/owncloud
cp $CONFIG_DIR/config.php /opt/config/config.php
chown 2002:nogroup /opt/config/owncloud /opt/config/owncloud/config.php /var/log/owncloud /srv/owncloud
rkt run [...] rkt.mafiasi.de/owncloud --exec /bin/bash
# run /var/www/owncloud/occ maintenance:install [...]
```

How to run:
```sh
rkt run --port=uwsgi:9787 --volume storage,kind=host,source=/srv/owncloud --volume config,kind=host,source=/opt/config/owncloud --volume log,kind=host,source=/var/log/owncloud --debug --interactive --dns=134.100.9.61 rkt.mafiasi.de/owncloud
```
