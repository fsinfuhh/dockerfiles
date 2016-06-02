% Mafiasi-Dashboard

UID: 2004

Ports:
- uwsgi

Mountpoints:
- config
- storage
- log


Initial steps:
```sh
mkdir -p /opt/config/dashboard /var/log/dashboard /srv/dashboard
cp $CONFIG_DIR/settings.py /opt/config/dashboard/settings.py
chown 2004:nogroup /opt/config/dashboard /opt/config/dashboard/settings.py /var/log/dashboard /srv/dashboard
```

How to run:
```sh
rkt run --port=uwsgi:3003 --volume storage,kind=host,source=/srv/dashboard --volume config,kind=host,source=/opt/config/dashboard --volume log,kind=host,source=/var/log/dashboard --dns=134.100.9.61 rkt.mafiasi.de/dashboard
```
