#! /bin/bash

LOCAL_PATH=../../opt/mafiasi-directory

GIT_HASH=`cd ${LOCAL_PATH} && git log -n 1 | grep commit | cut -d ' ' -f 2 | cut -b 1-6`
VERSION=2018.12.29-$GIT_HASH
NAME=directory

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-stretch

acbuild copy ${LOCAL_PATH} /opt/directory/
acbuild run -- /bin/bash -es <<"EOF"
    apt update
    usermod -u 2422 -g 33 -d /opt/directory www-data
    cd /opt/directory

    apt-get -y --no-install-recommends install uwsgi uwsgi-plugin-python uwsgi-plugin-python3 python3 python3-dev virtualenv python3-venv build-essential

    # Install python3 environment
    python3 -m venv .pyenv
    . .pyenv/bin/activate

    # Install python3 requirements
    pip install wheel
    pip install -r requirements.txt
    pip install uWSGI
    pip install raven
    pip install psycopg2-binary

    ln -sf /opt/config/settings.py /opt/directory/mafiasidirectory/settings.py

    # Cleanup
    apt-get -y purge build-essential
    apt-get -y autoremove
    apt-get clean

    # Install run-script
    cat > /usr/local/bin/run <<EOG
#!/bin/sh -e
export USER=www-data HOME=/opt/directory

cd /opt/directory

. .pyenv/bin/activate
./manage.py migrate
./manage.py collectstatic --noinput

# Actually start the server
exec uwsgi /etc/uwsgi/directory.ini
EOG
    chmod +x /usr/local/bin/run

EOF

acbuild copy uwsgi.ini /etc/uwsgi/directory.ini
acbuild port add uwsgi tcp 10000
acbuild mount add static /opt/static
acbuild mount add config /opt/config
acbuild set-user -- www-data
acbuild set-group -- www-data
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
