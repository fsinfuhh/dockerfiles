% Gitea - Git with a cup of tea

UID: 2001

Ports:
- web: 3005
- ssh: 3006

Mountpoints:
- /opt/config
- /opt/storage
- /opt/log


# Initial steps:
```sh
mkdir -p /opt/config/gitea /var/log/gitea /srv/gitea
cp $CONFIG_DIR/app.ini /opt/config/gitea/app.ini
vim !$ # Set options -- there will be a setup page on first run, too.
chown 2001:nogroup /opt/config/gitea /opt/config/gitea/app.ini /var/log/gitea /srv/gitea
```

The LDAP settings can be configured via the Web interface.
