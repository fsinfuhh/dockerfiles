% Redis

Simple redis instance. Can be used for creating pods that need a redis instance.
UID: 2002

Mountpoints:
- storage


Initial steps:
```sh
mkdir -p $STORAGE_DIR/redis $LOG_DIR
chown 2003:nogroup $STORAGE_DIR $STORAGE_DIR/redis $LOG_DIR
```

How to run:
This is not a standalone app and should be run with another app that needs redis, e.g. Owncloud.
```sh
rkt run --port=uwsgi:9787 --volume storage,kind=host,source=/srv/owncloud --volume config,kind=host,source=/opt/config/owncloud --volume log,kind=host,source=/var/log/owncloud --dns=134.100.9.61 rkt.mafiasi.de/owncloud rkt.mafiasi.de/redis
```
