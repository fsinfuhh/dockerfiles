#! /bin/bash

# Actung unten nochmal weil isso
#LOCAL_PATH=~nils/git/dudel-django/

#GIT_HASH=`cd ${LOCAL_PATH} && git log -n 1 | grep commit | cut -d ' ' -f 2 | cut -b 1-6`
GIT_HASH=$(wget -q --header="Accept: application/vnd.github.v3.sha" -O- https://api.github.com/repos/fsinfuhh/Bitpoll/commits/heads/master | cut -b 1-6)
VERSION=2017.07.13-$GIT_HASH
NAME=bitpoll

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-stretch

#acbuild copy ${LOCAL_PATH} /opt/bitpoll/
acbuild run -- /bin/sh -es <<"EOF"
    usermod -u 2008 -g nogroup -d /opt/bitpoll www-data
    apt-get -y --no-install-recommends install g++ wget uwsgi uwsgi-plugin-python python python-virtualenv python3-pip virtualenv make git python3-psycopg2 python3-ldap3 gettext gcc python3-dev libldap2-dev gpg curl libsasl2-dev

    curl -sL https://deb.nodesource.com/setup_8.x | bash -
    
    apt-get install -y --no-install-recommends  npm

    npm install cssmin uglify-js -g

    cd /opt
    wget -nv https://github.com/fsinfuhh/Bitpoll/archive/master.tar.gz -O- | tar -xz
    mv Bitpoll-master bitpoll
    #rm -rf /opt/bitpoll/.pyenv
    virtualenv --system-site-packages /opt/bitpoll/.pyenv -p `which python3`
    cd bitpoll
    . .pyenv/bin/activate
    pip install -U pip setuptools
    pip3 install -r requirements-production.txt
    ln -sf /opt/static/ /opt/bitpoll/_static
    cp bitpoll/settings_local.sample.py bitpoll/settings_local.py
    ./manage.py compilemessages
    chown 2008 -R _static
    chmod o+r -R .
    rm bitpoll/settings_local.py

    ln -sf /opt/config/settings.py /opt/bitpoll/bitpoll/settings_local.py
    ln -sf /opt/storage/media /opt/bitpoll/_media
    apt-get -y purge yui-compressor git python-pip make gcc python-dev libldap2-dev libsasl2-dev curl gpg
    apt-get -y autoremove
    apt-get clean

    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/home/www-data
. /opt/bitpoll/.pyenv/bin/activate
/opt/bitpoll/manage.py migrate
/opt/bitpoll/manage.py collectstatic --noinput
exec uwsgi /etc/uwsgi/bitpoll.ini
EOG
    chmod +x /usr/local/bin/run

EOF
echo $GIT_HASH > $T/.acbuild/currentaci/rootfs/opt/bitpoll/.gitversion
acbuild copy uwsgi-bitpoll.ini /etc/uwsgi/bitpoll.ini
acbuild port add uwsgi tcp 3008
acbuild mount add static /opt/static
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
