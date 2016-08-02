#! /bin/bash

VERSION=3.1.4

NAME=sogo

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base

acbuild run -- /usr/bin/env VERSION=$VERSION /bin/sh -es <<"EOF"
    adduser --disabled-login --gecos 'Sogo' --uid 2007 --ingroup nogroup sogo
    apt update
    apt-get --no-install-recommends -y install uwsgi memcached gnustep-make gnustep-base-runtime libgnustep-base-dev gobjc libxml2-dev libldap2-dev libssl-dev zlib1g-dev libpq-dev libmemcached-dev postgresql-client libcurl4-openssl-dev wget make

    mkdir /build && cd /build
    wget -q https://github.com/inverse-inc/sope/archive/SOPE-$VERSION.tar.gz -O- | tar -xz
    cd sope-SOPE-$VERSION
    ./configure --with-gnustep --disable-mysql
    make; make install

    cd /build

    wget -q https://github.com/inverse-inc/sogo/archive/SOGo-$VERSION.tar.gz -O- | tar -xz
    cd sogo-SOGo-$VERSION
    ./configure
    make; make install

    cd /
    rm -r /build

    apt-get -y remove wget make
    apt-get clean
    apt-get autoclean

    install -o sogo -g nogroup -m 750 -d /var/spool/sogo /etc/sogo
    ln -sf /opt/config/sogo.conf /etc/sogo/sogo.conf
    echo /usr/local/lib > /etc/ld.so.conf.d/sogo.conf
    echo /usr/local/lib/sogo > /etc/ld.so.conf.d/sogo.conf
    ldconfig

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