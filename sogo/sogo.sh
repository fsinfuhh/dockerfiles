#! /bin/bash

VERSION=2016.06.16-2
NAME=sogo
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci

. ../acbuildhelper.sh

echo "Building $IMAGE_NAME"

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-system

acbuild run -- /bin/sh -es <<"EOF"
    adduser --disabled-login --gecos 'Sogo' --uid 2007 --ingroup nogroup sogo
    echo deb http://inverse.ca/debian-v3 jessie jessie >> /etc/apt/sources.list
    apt-key adv --keyserver keys.gnupg.net --recv-key 0x19CDA6A9810273C4
    apt update
    apt-get --no-install-recommends -y install sogo sope4.9-gdl1-postgresql uwsgi memcached
    apt-get clean

    install -o sogo -g nogroup -m 750 -d /var/spool/sogo
    chown sogo:nogroup /etc/sogo
    ln -sf /opt/config/sogo.conf /etc/sogo/sogo.conf

    cat > /usr/local/bin/run <<"EOG"
#!/bin/sh -e
. /usr/share/GNUstep/Makefiles/GNUstep.sh

install -o sogo -g nogroup -m 755 -d /var/run/sogo
install -o sogo -g nogroup -m 750 -d /var/log/sogo

export USER=sogo HOME=/home/sogo
exec su -c 'uwsgi --ini /etc/uwsgi/sogo.ini' sogo
EOG
    chmod +x /usr/local/bin/run

EOF
acbuild copy  uwsgi-sogo.ini /etc/uwsgi/sogo.ini
acbuild port add web tcp 3007
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
