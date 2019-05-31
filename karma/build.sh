#! /bin/bash

LOCAL_PATH=../../Karma

GIT_HASH=`cd ${LOCAL_PATH} && git log -n 1 | grep commit | cut -d ' ' -f 2 | cut -b 1-6`
VERSION=2017.08.30-$GIT_HASH
NAME=karma

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-stretch

acbuild copy ${LOCAL_PATH} /opt/Karma/
acbuild run -- /bin/sh -es <<"EOF"
apt update
    usermod -u 2012 -g 33 -d /opt/Karma www-data
    apt-get -y --no-install-recommends install g++ wget uwsgi uwsgi-plugin-python uwsgi-plugin-python3 python python-virtualenv python3-pip virtualenv yui-compressor make git python3-psycopg2 python3-ldap3 gettext gcc python3-dev libldap2-dev libsasl2-dev

    cd /opt
    rm -rf /opt/Karma/.pyenv
    virtualenv /opt/Karma/.pyenv -p `which python3`
    cd Karma
    . .pyenv/bin/activate
    pip install -r requirements.txt
    pip install psycopg2
    pip install django-ldapdb
    pip install django-auth-ldap
    pip install uwsgi
    pip install raven
    pip install requests
    #yui-compressor /opt/imagetagger/imagetagger/imagetagger/annotations/static/annotations/js/annotations.js -o /opt/imagetagger/imagetagger/imagetagger/annotations/static/annotations/js/annotations.js

    ln -sf /opt/config/settings.py /opt/Karma/karma/settings.py
    ln -sf /opt/storage/static/ /opt/Karma/_static
    ln -sf /opt/storage/media /opt/Karma/_media
    apt-get -y purge yui-compressor git python-pip make gcc python-dev libldap2-dev libsasl2-dev
    apt-get -y autoremove
    apt-get clean

    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
. /opt/Karma/.pyenv/bin/activate
/opt/Karma/manage.py migrate
/opt/Karma/manage.py collectstatic --noinput
exec uwsgi /etc/uwsgi/karma.ini
EOG
    chmod +x /usr/local/bin/run

EOF
echo $GIT_HASH > $T/.acbuild/currentaci/rootfs/opt/Karma/.gitversion
acbuild copy uwsgi-karma.ini /etc/uwsgi/karma.ini
acbuild port add uwsgi tcp 3005
acbuild mount add static /opt/static
acbuild mount add config /opt/config
acbuild mount add storage /opt/storage
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- www-data
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
