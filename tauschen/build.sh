#! /bin/bash

LOCAL_PATH=../../mafiasi-tauschen
LOCAL_DIRECTORY_PATH=../../mafiasi-directory

GIT_HASH=`cd ${LOCAL_PATH} && git log -n 1 | grep commit | cut -d ' ' -f 2 | cut -b 1-6`
VERSION=2018.11.08-$GIT_HASH
NAME=tauschen

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-stretch

acbuild copy ${LOCAL_PATH} /opt/tauschen
acbuild copy ${LOCAL_DIRECTORY_PATH} /opt/directory
acbuild run -- /bin/bash -es <<"EOF"
    apt update
    usermod -u 2009 -g 33 -d /opt/tauschen www-data
    cd /opt/tauschen

    # Install linux dependencies
    apt-get -y --no-install-recommends install curl gnupg
    curl -sL https://deb.nodesource.com/setup_11.x | bash -
    apt-get -y --no-install-recommends install g++ wget uwsgi uwsgi-plugin-python uwsgi-plugin-python3 python3 libldap2-dev libsasl2-dev libssl-dev python3-dev virtualenv npm

    # Install python3 environment
    cd tauschen-backend
    rm -rf .pyenv venv
    virtualenv ./.pyenv -p `which python3`
    source .pyenv/bin/activate

    # Install python3 requirements
    pip install -r requirements.txt
    pip install uWSGI

    # Setup tauschen-backend
    ln -sf /opt/config/settings.py /opt/tauschen/tauschen-backend/tauschen/settings.py
    pip install /opt/directory

    # Build frontend
    cd /opt/tauschen/tauschen-frontend
    rm -rf node_modules
    npm install yarn --global
    yarn install
    yes no | yarn global add @angular/cli
    ng build --prod --subresource-integrity --optimization --aot --source-map
    
    # Cleanup
    apt-get -y autoremove
    apt-get clean
    


    # Install run-script
    cat > /usr/local/bin/run <<EOG
        #!/bin/bash
        export USER=www-data HOME=/home/www-data

        # Deploy newest backend
        source /opt/tauschen/tauschen-backend/.pyenv/bin/activate
        /opt/tauschen/tauschen-backend/manage.py migrate
        /opt/tauschen/tauschen-backend/manage.py collectstatic --noinput

        # Deploy newest frontend
        cp -rT /opt/tauschen/tauschen-frontend/dist/tauschen-frontend /opt/static/tauschen-frontend/

        # Actually start the server
        exec uwsgi /etc/uwsgi/tauschen.ini
EOG
    chmod +x /usr/local/bin/run

EOF

acbuild copy uwsgi-tauschen.ini /etc/uwsgi/tauschen.ini
acbuild port add uwsgi tcp 3008
acbuild mount add static /opt/static
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- www-data
acbuild set-exec -- /bin/bash /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
