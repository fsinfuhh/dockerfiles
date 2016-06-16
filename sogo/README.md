% Sogo

UID: 2007

Ports:
- web: 3007

Mountpoints:
- config
- log

# Initial steps:
```sh
mkdir -p /opt/config/sogo /var/log/sogo
cp $CONFIG_DIR/sogo.conf /opt/config/sogo/sogo.conf
vim !$ # Set options
chown 2007:nogroup /opt/config/sogo /opt/config/sogo/sogo.conf /var/log/sogo
```

# How to run:

```sh
rkt run --port=web:3007 --volume config,kind=host,source=/opt/config/sogo --volume log,kind=host,source=/var/log/sogo --debug --interactive --dns=134.100.9.61 rkt.mafiasi.de/sogo
```
