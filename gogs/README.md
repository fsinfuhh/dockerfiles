% Gogs - Go Git Service

UID: 2001

Ports:
- ssh: 22
- web: 3005

Mountpoints:
- config
- storage
- log


# Initial steps:
```sh
mkdir -p /opt/config/gogs /var/log/gogs /srv/gogs
cp $CONFIG_DIR/app.ini /opt/config/gogs/app.ini
vim !$ # Set options -- there will be a setup page on first run, too.
chown 2001:nogroup /opt/config/gogs /opt/config/gogs/app.ini /var/log/gogs /srv/gogs
```

The LDAP settings can be configured via the Web interface.

# How to run:

## Option 1: Port 22 of the host will be forwarded to the ssh daemon of the container.
```sh
rkt run --port=web:3005 --port=ssh:22 --volume storage,kind=host,source=/srv/gogs --volume config,kind=host,source=/opt/config/gogs --volume log,kind=host,source=/var/log/gogs --debug --interactive --dns=134.100.9.61 rkt.mafiasi.de/gogs
```

## Option 2: The host runs a sshd that will accept ssh connections on port 22 and forwards the data transparently to the container:

Additional setup:
```sh
adduser --home $GOGS_STORAGE/gituser --shell $GOGS_STORAGE/gogs-shell --uid 2001 gogs
su -c "ssh-keygen -t ed25519; cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys" gogs
cp gogs-shell $GOGS_STORAGE/gogs-shell
```

Run:
```sh
rkt run --port=web:3005 --volume storage,kind=host,source=/srv/gogs --volume config,kind=host,source=/opt/config/gogs --volume log,kind=host,source=/var/log/gogs --debug --interactive --dns=134.100.9.61 rkt.mafiasi.de/gogs
```
