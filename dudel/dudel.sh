#! /bin/bash

VERSION=2016.05.24
NAME=dudel
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci

. ../acbuildhelper.sh

echo "Building $IMAGE_NAME"

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-system

acbuild run -- /bin/sh -es <<"EOF"
    usermod -u 2006 -g nogroup www-data
    apt update
    apt-get -y --no-install-recommends install wget uwsgi uwsgi-plugin-python python python-virtualenv python-pip virtualenv yui-compressor make git python-psycopg2 python-flask-sqlalchemy python-ldap python-magic python-requests gettext gcc python-dev python-scrypt

    cd /opt
    wget -nv https://github.com/opatut/dudel/archive/hotfix.tar.gz -O- | tar -xz
    mv dudel-hotfix dudel
    virtualenv --system-site-packages /opt/dudel/.pyenv
    cd dudel
    . .pyenv/bin/activate
    pip install -r requirements.txt
    pip install -U flask-login==0.2.11

    make i18n-compile
    mv config.py.example config.py

    ln -sf /opt/config/config.py /opt/dudel/config.py
    
    apt-get -y purge yui-compressor git python-pip make gcc python-dev
    apt-get -y autoremove
    apt-get clean
    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
. /opt/dudel/.pyenv/bin/activate
exec uwsgi /etc/uwsgi/dudel.ini
EOG
    chmod +x /usr/local/bin/run

EOF
acbuild copy uwsgi-dudel.ini /etc/uwsgi/dudel.ini
acbuild port add uwsgi tcp 3003
acbuild mount add storage /opt/storage
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
