#! /bin/bash

VERSION=2016.05.19
NAME=dashboard
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci

. ../acbuildhelper.sh

echo "Building $IMAGE_NAME"

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-system

acbuild run -- /bin/sh -es <<"EOF"
    usermod -u 2002 -g nogroup www-data
    apt-get -y --no-install-recommends install wget uwsgi python python-virtualenv python-pip virtualenv yui-compressor make

    virtualenv /opt/dashboard
    cd /opt/dashboard
    . ./bin/activate
    wget -nv https://github.com/fsinfuhh/mafiasi/archive/master.tar.gz | tar -xz
    pip install -r requirements.txt
    make
    ./manage.py collectstatic


    ln -sf /opt/config/settings.py /opt/dashboard/mafiasi/settings.py
    ln -sf /opt/storage/_media /opt/dashboard/_media

    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
exec uwsgi /etc/uwsgi/dashboard.ini
EOG
    chmod +x /usr/local/bin/run

EOF
acbuild copy uwsgi-dashboard.ini /etc/uwsgi/dashboard.ini
acbuild port add uwsgi tcp 3003
acbuild mount add storage /opt/storage
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
