#! /bin/bash

LOCAL_PATH=../../opt/imagetagger

GIT_HASH=`cd ${LOCAL_PATH} && git log -n 1 | grep commit | cut -d ' ' -f 2 | cut -b 1-6`
VERSION=2017.06.29-$GIT_HASH
NAME=imagetagger

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-stretch

acbuild copy ${LOCAL_PATH} /opt/imagetagger/
acbuild run -- /bin/sh -es <<"EOF"
apt update
    usermod -u 5008 -g nogroup -d /opt/imagetagger www-data
    apt-get -y --no-install-recommends install g++ wget uwsgi uwsgi-plugin-python python python-virtualenv python3-pip virtualenv yui-compressor make git python3-psycopg2 python3-ldap3 gettext gcc python3-dev libldap2-dev libsasl2-dev

    cd /opt
    rm -rf /opt/imagetagger/.pyenv
    virtualenv /opt/imagetagger/.pyenv -p `which python3`
    cd imagetagger
    . .pyenv/bin/activate
    pip3 install -r requirements.txt
    pip3 install psycopg2
    pip3 install django-ldapdb
    pip3 install django-auth-ldap
    pip3 install uwsgi
    pip3 install raven

    ln -sf /opt/config/settings.py /opt/imagetagger/imaggetagger/imaggetagger/settings.py
    apt-get -y purge yui-compressor git python-pip make gcc python-dev libldap2-dev libsasl2-dev
    apt-get -y autoremove
    apt-get clean

    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
. /opt/imagetagger/.pyenv/bin/activate
/opt/imagetagger/imaggetagger/manage.py migrate
/opt/imagetagger/imaggetagger/manage.py collectstatic --noinput
exec uwsgi /etc/uwsgi/imagetagger.ini
EOG
    chmod +x /usr/local/bin/run

EOF
echo $GIT_HASH > $T/.acbuild/currentaci/rootfs/opt/imagetagger/.gitversion
acbuild copy uwsgi-imagetagger.ini /etc/uwsgi/imagetagger.ini
acbuild port add uwsgi tcp 3008
acbuild mount add static /opt/static
acbuild mount add config /opt/config
acbuild mount add storage /opt/storage
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
