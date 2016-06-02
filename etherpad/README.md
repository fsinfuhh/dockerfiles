% Mafiasi-Dashboard

UID: 2005

Ports:
- www

Mountpoints:
- config
- log


Initial steps:
```sh
mkdir -p /opt/config/etherpad /var/log/etherpad /srv/etherpad
cp $CONFIG_DIR/settings.json /opt/config/etherpad/settings.json
cp $CONFIG_DIR/APIKEY.txt /opt/config/etherpad/APIKEY.txt
chown 2005:nogroup /opt/config/etherpad /opt/config/etherpad/settings.json /opt/config/etherpad/APIKEY.txt /var/log/etherpad
```

How to run:
```sh
rkt run --port=uwsgi:3003  --volume config,kind=host,source=/opt/config/etherpad --volume log,kind=host,source=/var/log/etherpad --dns=134.100.9.61 rkt.mafiasi.de/dashboard
```
