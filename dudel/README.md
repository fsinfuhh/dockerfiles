% Dudel

UID: 2006

Ports:
- uwsgi

Mountpoints:
- config
- log


Initial steps:
```sh
mkdir -p /opt/config/dudel /var/log/dudel
cp $CONFIG_DIR/settings.py /opt/config/settings.py
chown 2006:nogroup /opt/config/dudel /opt/config/dudel/settings.py /var/log/dudel /srv/dudel
```

How to run:
```sh
rkt run --port=uwsgi:3006 --volume storage,kind=host,source=/srv/dudel --volume config,kind=host,source=/opt/config/dudel --volume log,kind=host,source=/var/log/dudel --dns=134.100.9.61 rkt.mafiasi.de/dudel
```
