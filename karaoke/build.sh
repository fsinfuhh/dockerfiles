#! /bin/bash

# Actung unten nochmal weil isso
LOCAL_PATH=../../opt/MafiAStar

GIT_HASH=`cd ${LOCAL_PATH} && git log -n 1 | grep commit | cut -d ' ' -f 2 | cut -b 1-6`
#$(wget -q --header="Accept: application/vnd.github.v3.sha" -O- https://api.github.com/repos/fsinfuhh/mafiasi/commits/heads/feature_cml | cut -b 1-6)
VERSION=2017.05.31-$GIT_HASH
NAME=karaoke

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base

acbuild copy ${LOCAL_PATH} /opt/MafiAStar/
acbuild run -- /bin/sh -es <<"EOF"
apt update
    usermod -u 2008 -g nogroup -d /opt/MafiAStar www-data
    apt-get -y --no-install-recommends install g++ wget uwsgi uwsgi-plugin-python python python-virtualenv python3-pip virtualenv yui-compressor make git python3-psycopg2 python3-ldap3 gettext gcc python3-dev libldap2-dev libsasl2-dev coffeescript ruby-sass

    cd /opt
    #wget -nv https://github.com/fsinfuhh/MafiAStar/archive/master.tar.gz -O- | tar -xz
    #mv MafiAStar-master MafiAStar
    rm -rf /opt/MafiAStar/.pyenv
    virtualenv --system-site-packages /opt/MafiAStar/.pyenv -p `which python3`
    cd MafiAStar
    . .pyenv/bin/activate
    pip3 install -r requirements.txt
    pip3 install -U 'Django<1.12'
    pip3 install django-ldapdb
    pip3 install django-auth-ldap
    pip3 install uwsgi
    pip3 install raven
    #make
    #mv MafiAStar/settings.py.example MafiAStar/settings.py
    #./manage.py collectstatic --noinput --link
    ./manage.py compilemessages
    #chown 2008 -R _static

    ln -sf /opt/config/settings.py /opt/MafiAStar/MafiAStar/settings.py
    #ln -s /opt/config/services.py /opt/MafiAStar/MafiAStar/services.py
    ln -sf /opt/storage/media /opt/MafiAStar/_media
    #ln -sf /opt/static/ /opt/MafiAStar/_static
    apt-get -y purge yui-compressor git python-pip make gcc python-dev libldap2-dev libsasl2-dev
    apt-get -y autoremove
    apt-get clean

    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
. /opt/MafiAStar/.pyenv/bin/activate
/opt/MafiAStar/manage.py migrate
/opt/MafiAStar/manage.py collectstatic --noinput
exec uwsgi /etc/uwsgi/mafiastar.ini
EOG
    chmod +x /usr/local/bin/run

EOF
echo $GIT_HASH > $T/.acbuild/currentaci/rootfs/opt/MafiAStar/.gitversion
acbuild copy uwsgi-mafiastar.ini /etc/uwsgi/mafiastar.ini
acbuild port add uwsgi tcp 3008
acbuild mount add static /opt/static
acbuild mount add config /opt/config
acbuild mount add storage /opt/storage
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
