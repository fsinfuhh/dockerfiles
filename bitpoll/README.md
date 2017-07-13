% Mafiasi-Dashboard

UID: 2008

Ports:
- uwsgi 3008

Mountpoints:
- config
- storage
- log


Initial steps:
```sh
mkdir -p /opt/config/dudel2 /var/log/dudel2 /srv/dudel2
cp $CONFIG_DIR/settings.py /opt/config/dudel2/settings.py
chown 2008:nogroup /opt/config/dudel2 /opt/config/dudel2/settings.py /var/log/dudel2 /srv/dudel2
```

How to run:
```sh
rkt run --port=uwsgi:3008 --volume storage,kind=host,source=/srv/dudel2 --volume config,kind=host,source=/opt/config/dudel2 --volume log,kind=host,source=/var/log/dudel2 --dns=134.100.9.61 rkt.mafiasi.de/dudel2
```
