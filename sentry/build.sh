#! /bin/bash
VERSION=$(curl https://pypi.python.org/pypi/sentry 2> /dev/null | grep -oE "sentry-[0-9]+\.[0-9]+\.[0-9]+" | head -n 1 | sed "s/sentry-//g")
NAME=sentry

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base

acbuild copy uwsgi.ini /opt/sentry/uwsgi.ini

acbuild run -- /usr/bin/env VERSION=$VERSION /bin/sh -es <<"EOF"
    useradd -u 3080 -g nogroup -d /opt/sentry sentry
    apt update
    apt-get -y --no-install-recommends install python-setuptools python-pip python-dev libxslt1-dev gcc libffi-dev libjpeg-dev libxml2-dev libxslt-dev libyaml-dev libpq-dev

    # install python dependencies
    cd /opt/sentry
    pip install virtualenv
    virtualenv --python /usr/bin/python2 /opt/sentry/.pyenv
    . /opt/sentry/.pyenv/bin/activate
    pip install sentry

    # link configuration
    ln -s /opt/config/config.yml config.yml
    ln -s /opt/config/sentry.conf.py sentry.conf.py

    chown -R sentry:nogroup /opt/sentry
 
    apt -y purge python-pip python-setuptools build-essential
    apt-get -y autoremove
    apt-get clean
    rm -rf /var/cache
    rm -rf /var/log/*
    rm -rf /var/lib

    # store startup scripts
    cat > /opt/sentry/run <<EOG
#!/bin/sh
cd /opt/sentry
. .pyenv/bin/activate
SENTRY_CONF=/opt/sentry /opt/sentry/.pyenv/bin/sentry run \$1
EOG
    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=sentry HOME=/opt/sentry
cd /opt/sentry
. /opt/sentry/.pyenv/bin/activate
SENTRY_CONF=/opt/sentry /opt/sentry/.pyenv/bin/sentru upgrade
exec uwsgi /opt/sentry/uwsgi.ini
EOG
    chmod +x /usr/local/bin/run
    chmod +x /opt/sentry/run

EOF

acbuild port add web tcp 10000
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-user -- sentry
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
