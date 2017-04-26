#! /bin/bash

# Actung unten nochmal weil isso
LOCAL_PATH=/home/nils/git/dudel-django/

GIT_HASH=`cd ${LOCAL_PATH} && git log -n 1 | grep commit | cut -d ' ' -f 2 | cut -b 1-6`
#$(wget -q --header="Accept: application/vnd.github.v3.sha" -O- https://api.github.com/repos/fsinfuhh/mafiasi/commits/heads/feature_cml | cut -b 1-6)
VERSION=2017.04.12-$GIT_HASH
NAME=dudel2

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base

acbuild copy ${LOCAL_PATH} /opt/dudel2/
acbuild run -- /bin/sh -es <<"EOF"
    usermod -u 2008 -g nogroup -d /opt/dudel2 www-data
    apt-get -y --no-install-recommends install g++ wget uwsgi uwsgi-plugin-python python python-virtualenv python3-pip virtualenv yui-compressor make git python3-psycopg2 python3-ldap3 gettext gcc python3-dev libldap2-dev libsasl2-dev coffeescript ruby-sass

    cd /opt
    #wget -nv https://github.com/fsinfuhh/dudel2/archive/master.tar.gz -O- | tar -xz
    #mv dudel2-master dudel2
    rm -rf /opt/dudel2/.pyenv
    virtualenv --system-site-packages /opt/dudel2/.pyenv -p `which python3`
    cd dudel2
    . .pyenv/bin/activate
    pip3 install -r requirements.txt
    pip3 install -U 'Django<1.12'
    pip3 install django-ldapdb
    pip3 install django-auth-ldap
    pip3 install uwsgi
    pip3 install raven
    #make
    mv dudel/settings.py.example dudel/settings.py
    ./manage.py compilestatic
    ./manage.py collectstatic --noinput --link
    ./manage.py compilemessages
    chown 2008 -R _static

    ln -sf /opt/config/settings.py /opt/dudel2/dudel/settings.py
    ln -s /opt/config/services.py /opt/dudel2/dudel/services.py
    ln -sf /opt/storage/media /opt/dudel2/_media
    #ln -sf /opt/static/ /opt/dudel/_static
    apt-get -y purge yui-compressor git python-pip make gcc python-dev libldap2-dev libsasl2-dev
    apt-get -y autoremove
    apt-get clean

    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
. /opt/dudel2/.pyenv/bin/activate
/opt/dudel2/manage.py migrate
/opt/dudel2/manage.py compilestatic
exec uwsgi /etc/uwsgi/dudel2.ini
EOG
    chmod +x /usr/local/bin/run

EOF
echo $GIT_HASH > $T/.acbuild/currentaci/rootfs/opt/dudel2/.gitversion
acbuild copy uwsgi-dudel2.ini /etc/uwsgi/dudel2.ini
acbuild port add uwsgi tcp 3008
acbuild mount add static /opt/static
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
