#! /bin/bash

GIT_HASH=$(wget -q --header="Accept: application/vnd.github.v3.sha" -O- https://api.github.com/repos/fsinfuhh/mafiasi/commits/heads/feature_cml | cut -b 1-6)
VERSION=2016.08.02-$GIT_HASH
NAME=dashboard

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base

acbuild run -- /bin/sh -es <<"EOF"
    usermod -u 2004 -g nogroup -d /opt/dashboard www-data
    apt-get -y --no-install-recommends install wget uwsgi uwsgi-plugin-python python python-virtualenv python-pip virtualenv yui-compressor make git python-bleach python-creoleparser python-django-auth-ldap python-pil python-psycopg2 python-gpgme python-pygraphviz python-pypdf2 python-ldap python-magic python-requests gettext gcc python-dev libldap2-dev libsasl2-dev

    cd /opt
    wget -nv https://github.com/fsinfuhh/mafiasi/archive/feature_cml.tar.gz -O- | tar -xz
    mv mafiasi-feature_cml dashboard
    virtualenv --system-site-packages /opt/dashboard/.pyenv
    cd dashboard
    . .pyenv/bin/activate
    pip install -r requirements.txt
    pip install -U 'Django<1.11'
    pip install django-ldapdb
    make
    mv mafiasi/settings.py.example mafiasi/settings.py
    ./manage.py collectstatic --noinput --link


    ln -sf /opt/config/settings.py /opt/dashboard/mafiasi/settings.py
    ln -sf /opt/storage/media /opt/dashboard/_media
    apt-get -y purge yui-compressor git python-pip make gcc python-dev libldap2-dev libsasl2-dev
    apt-get -y autoremove
    apt-get clean

    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
. /opt/dashboard/.pyenv/bin/activate
/opt/dashboard/manage.py migrate
exec uwsgi /etc/uwsgi/dashboard.ini
EOG
    chmod +x /usr/local/bin/run

EOF
echo $GIT_HASH > $T/.acbuild/currentaci/rootfs/opt/dashboard/.gitversion
acbuild copy uwsgi-dashboard.ini /etc/uwsgi/dashboard.ini
acbuild port add uwsgi tcp 3003
acbuild mount add storage /opt/storage
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
