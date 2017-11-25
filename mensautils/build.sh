#!/bin/bash

NAME=mensautils
LOCAL_PATH="../../opt/mensa-utils"
GIT_HASH="$(cd ${LOCAL_PATH} && git log -n 1 | grep commit | cut -d ' ' -f 2 | cut -b 1-7)"
VERSION="2017.11.25.-${GIT_HASH}"

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/${NAME}
acbuild dependency add rkt.mafiasi.de/base-stretch
acbuild copy ${LOCAL_PATH} /opt/mensautils/

acbuild run -- /usr/bin/env VERSION="${VERSION}" /bin/sh -es <<"EOF"
    useradd -u 2009 -g nogroup -d /opt/mensautils mensautils
    chown -R mensautils /opt/mensautils
    chmod o+r -R /opt/mensautils

    echo "$VERSION" > /opt/mensautils/.version

    apt update
    apt-get -y --no-install-recommends install gcc wget make git uwsgi virtualenv gettext python3 uwsgi-plugin-python3 python3-virtualenv python3-pip python3-psycopg2 python3-ldap3 python3-dev libldap2-dev libsasl2-dev
    # uwsgi-plugin-python

    su mensautils -s /bin/bash <<"EOG"
        cd /opt/mensautils

        rm -rf .pyenv
        rm -f  mensautils/settings.py.example

        virtualenv .pyenv -p "$(which python3)"
        . .pyenv/bin/activate

        pip install -r requirements.txt
        pip install psycopg2
        pip install django-ldapdb
        pip install django-auth-ldap
        pip install django-debug-toolbar
        pip install uwsgi
        pip install raven
EOG

    ln -sf /opt/static/ /opt/mensautils/_static
    ln -sf /opt/config/settings.py /opt/mensautils/mensautils/settings.py

    apt-get -y purge git python3-pip make gcc python3-dev libldap2-dev libsasl2-dev
    apt-get -y autoremove
    apt-get clean

    # store startup script
    cat > /usr/local/bin/run <<"EOG"
        #!/bin/sh
        export USER=mensautils HOME=/opt/mensautils
        . /opt/mensautils/.pyenv/bin/activate
        /opt/mensautils/manage.py migrate
        /opt/mensautils/manage.py collectstatic --noinput
        exec uwsgi_python35 /etc/uwsgi/mensautils.ini
EOG

    chmod +x /usr/local/bin/run
EOF

acbuild copy uwsgi-mensautils.ini /etc/uwsgi/mensautils.ini
acbuild port add web tcp 10000
acbuild mount add config /opt/config
acbuild mount add static /opt/static
acbuild mount add log /opt/log
acbuild set-user -- mensautils
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite "${IMAGE_NAME}"
