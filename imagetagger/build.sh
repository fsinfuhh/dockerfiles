#! /bin/bash

LOCAL_PATH=../../opt/imagetagger

GIT_HASH=`cd ${LOCAL_PATH} && git log -n 1 | grep commit | cut -d ' ' -f 2 | cut -b 1-6`
VERSION=2018.05.04-$GIT_HASH
NAME=imagetagger

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-stretch

acbuild copy ${LOCAL_PATH} /opt/imagetagger/
acbuild run -- /bin/sh -es <<"EOF"
apt update
    usermod -u 5008 -g 33 -d /opt/imagetagger www-data
    apt-get -y --no-install-recommends install g++ wget uwsgi uwsgi-plugin-python uwsgi-plugin-python3 python python-virtualenv python3-pip virtualenv node-uglify make git python3-psycopg2 python3-ldap3 gettext gcc python3-dev libldap2-dev libsasl2-dev

    cd /opt
    rm -rf /opt/imagetagger/.pyenv
    virtualenv /opt/imagetagger/.pyenv -p `which python3`
    cd imagetagger
    . .pyenv/bin/activate
    pip install -r requirements.txt
    pip install psycopg2
    pip install django-ldapdb
    pip install django-auth-ldap
    pip install uwsgi
    pip install raven
    pip install requests
    #uglifyjs /opt/imagetagger/imagetagger/imagetagger/annotations/static/annotations/js/annotations.js -o /opt/imagetagger/imagetagger/imagetagger/annotations/static/annotations/js/annotations.js

    ln -sf /opt/config/settings.py /opt/imagetagger/imagetagger/imagetagger/settings.py
    apt-get -y purge node-uglify git python-pip make gcc python-dev libldap2-dev libsasl2-dev
    apt-get -y autoremove
    apt-get clean

    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
. /opt/imagetagger/.pyenv/bin/activate
/opt/imagetagger/imagetagger/manage.py migrate
/opt/imagetagger/imagetagger/manage.py collectstatic --noinput
exec uwsgi /etc/uwsgi/imagetagger.ini
EOG
    chmod +x /usr/local/bin/run

    cat > /usr/local/bin/update_points <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
. /opt/imagetagger/.pyenv/bin/activate
exec /opt/imagetagger/imagetagger/manage.py updatepoints
EOG
    chmod +x /usr/local/bin/update_points

    cat > /usr/local/bin/zip_daemon <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
. /opt/imagetagger/.pyenv/bin/activate
exec /opt/imagetagger/imagetagger/manage.py runzipdaemon
EOG
    chmod +x /usr/local/bin/zip_daemon


EOF
echo $GIT_HASH > $T/.acbuild/currentaci/rootfs/opt/imagetagger/.gitversion
acbuild copy uwsgi-imagetagger.ini /etc/uwsgi/imagetagger.ini
acbuild port add uwsgi tcp 3008
acbuild mount add static /opt/static
acbuild mount add config /opt/config
acbuild mount add storage /opt/storage
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- www-data
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
