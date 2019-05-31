#! /bin/bash

LOCAL_PATH=../../familiendoel-auswerter

GIT_HASH=`cd ${LOCAL_PATH} && git log -n 1 | grep commit | cut -d ' ' -f 2 | cut -b 1-6`
VERSION=2018.10.08-$GIT_HASH
NAME=familiendoel

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-stretch

acbuild copy ${LOCAL_PATH} /opt/familiendoel/
acbuild run -- /bin/sh -es <<"EOF"
apt update
    usermod -u 2013 -g 33 -d /opt/familiendoel www-data
    apt-get -y --no-install-recommends install g++ wget uwsgi uwsgi-plugin-python uwsgi-plugin-python3 python python-virtualenv python3-pip virtualenv node-uglify make git python3-psycopg2 python3-ldap3 gettext gcc python3-dev libldap2-dev libsasl2-dev

    cd /opt
    rm -rf /opt/familiendoel/.pyenv
    virtualenv /opt/familiendoel/.pyenv -p `which python3`
    cd familiendoel
    . .pyenv/bin/activate
    pip install -r requirements.txt
    pip install psycopg2
    pip install django-ldapdb
    pip install django-auth-ldap
    pip install uwsgi
    pip install raven
    pip install requests
    #uglifyjs /opt/imagetagger/imagetagger/imagetagger/annotations/static/annotations/js/annotations.js -o /opt/imagetagger/imagetagger/imagetagger/annotations/static/annotations/js/annotations.js
    ls /opt/familiendoel/familiendoellauswerter/
    ls /opt/familiendoel/familiendoellauswerter/familiendoellauswerter
    ln -sf /opt/config/settings.py /opt/familiendoel/familiendoellauswerter/familiendoellauswerter /
    ln -sf /opt/config/settings.py /opt/familiendoel/familiendoellauswerter/familiendoellauswerter/settings.py
    ln -sf /opt/storage/static/ /opt/familiendoel/familiendoellauswerter/_static
    #ln -sf /opt/storage/media /opt/familiendoel/familiendoellauswerter/_media
    apt-get -y purge node-uglify git python-pip make gcc python-dev libldap2-dev libsasl2-dev
    apt-get -y autoremove
    apt-get clean

    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
. /opt/familiendoel/.pyenv/bin/activate
/opt/familiendoel/familiendoellauswerter/manage.py migrate
/opt/familiendoel/familiendoellauswerter/manage.py collectstatic --noinput
exec uwsgi /etc/uwsgi/familiendoel.ini
EOG
    chmod +x /usr/local/bin/run

EOF
echo $GIT_HASH > $T/.acbuild/currentaci/rootfs/opt/familiendoel/.gitversion
acbuild copy uwsgi-familiendoel.ini /etc/uwsgi/familiendoel.ini
acbuild port add uwsgi tcp 3008
acbuild mount add static /opt/static
acbuild mount add config /opt/config
acbuild mount add storage /opt/storage
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- www-data
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
