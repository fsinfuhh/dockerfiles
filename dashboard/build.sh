#! /bin/bash

GIT_HASH=$(wget -q --header="Accept: application/vnd.github.v3.sha" -O- https://api.github.com/repos/fsinfuhh/mafiasi/commits/heads/feature_cml | cut -b 1-6)
VERSION=2017.12.18-$GIT_HASH
NAME=dashboard

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-stretch

acbuild run -- /bin/sh -es <<"EOF"
    usermod -u 2004 -g nogroup -d /opt/dashboard www-data
    apt-get -y --no-install-recommends install wget uwsgi uwsgi-plugin-python python3 python-virtualenv python3-pip virtualenv yui-compressor make git python3-bleach python3-pil python3-psycopg2 python3-gpgme python3-pygraphviz python3-pypdf2 python3-magic gettext gcc python3-dev libldap2-dev libsasl2-dev make

    cd /opt
    wget -nv https://github.com/fsinfuhh/mafiasi/archive/feature-python3.tar.gz -O- | tar -xz
    mv mafiasi-feature-python3 dashboard
    virtualenv --system-site-packages -p `which python3` /opt/dashboard/.pyenv
    cd dashboard
    . .pyenv/bin/activate
    pip install -r requirements.txt
    pip install -U 'Django<2.1'
    pip install django-ldapdb
    pip install uwsgi
    ln -sf /opt/storage/static/ /opt/dashboard/_static
    ln -sf /opt/storage/.gnupg /opt/dashboard
    mv mafiasi/settings.py.example mafiasi/settings.py
    #./manage.py collectstatic --noinput --link
    ./manage.py compilemessages


    ln -sf /opt/config/settings.py /opt/dashboard/mafiasi/settings.py
    ln -s /opt/config/services.py /opt/dashboard/mafiasi/services.py
    ln -sf /opt/storage/media /opt/dashboard/_media
    apt-get -y purge git python-pip make gcc python-dev libldap2-dev libsasl2-dev
    apt-get -y autoremove
    apt-get clean

    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/opt/dashboard/
. /opt/dashboard/.pyenv/bin/activate
/opt/dashboard/manage.py migrate
cd /opt/dashboard
make
/opt/dashboard/manage.py collectstatic
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
