% Gogs - Go Git Service

UID: 2001

Ports:
- ssh
- web

Mountpoints:
- config
- storage
- log


Initial steps:
```sh
mkdir -p /opt/config/gogs /var/log/gogs /srv/gogs
cp $CONFIG_DIR/app.ini /opt/config/gogs/app.ini
vim !$ # Set DB options
chown 2001:nogroup /opt/config/gogs /opt/config/gogs/app.ini /var/log/gogs /srv/gogs
```

How to run:
```sh
rkt run --port=web:3000 --port=ssh:22 --volume storage,kind=host,source=/srv/gogs --volume config,kind=host,source=/opt/config/gogs --volume log,kind=host,source=/var/log/gogs --debug --interactive --dns=134.100.9.61 rkt.mafiasi.de/gogs
```
