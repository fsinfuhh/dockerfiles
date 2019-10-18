#! /bin/bash

LOCAL_PATH=../../marv-robotics/

GIT_HASH=`cd ${LOCAL_PATH} && git log -n 1 | grep commit | cut -d ' ' -f 2 | cut -b 1-6`
VERSION=`date --iso-8601=date`-$GIT_HASH
NAME=marv

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-stretch

acbuild copy ${LOCAL_PATH} /opt/marv
acbuild run -- /bin/bash -es <<"EOF"
    apt update
    usermod -u 2009 -g 33 -d /opt/marv www-data
    cd /opt/marv

    # Install linux dependencies
    export DEBIAN_FRONTEND=noninteractive
    apt-get -y --no-install-recommends install dirmngr g++ gnupg lsb-release uwsgi uwsgi-plugin-python libldap2-dev libsasl2-dev libssl-dev virtualenv ffmpeg jq less libcapnp-dev libffi-dev libfreetype6-dev libpng-dev libsasl2-dev libssl-dev libz-dev locales lsof python-cv-bridge python2.7-dev python-opencv python-pip rsync sqlite3 ssh unzip vim

    # Install ROS
    echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
    apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
    apt update
    apt install ros-melodic-ros-base

    # Install python environment
    rm -rf .pyenv venv
    virtualenv venv -p `which python2`
    source venv/bin/activate

    # Install python requirements
    pip install -r requirements/marv-cli.txt
    pip install -r requirements/marv.txt
    pip install -r requirements/marv-robotics.txt

    # Setup marv
    mkdir -p /opt/marv/sites/cml
    ln -sf /opt/config/marv.conf /opt/marv/sites/cml/marv.conf
    ln -sf /opt/config/uwsgi.conf /opt/marv/sites/cml/uwsgi.conf
    cp -r requirements /requirements
    pip install --no-deps code/marv-cli
    pip install --no-deps code/marv
    pip install --no-deps code/marv-robotics

    # Cleanup
    apt -y autoremove
    apt clean

    # Install run-script
    cat > /usr/local/bin/run <<EOG
        #!/bin/bash
        export USER=www-data HOME=/home/www-data

        # Actually start the server
        exec uwsgi --ini /opt/config/uwsgi.conf
EOG
    chmod +x /usr/local/bin/run

EOF

acbuild port add uwsgi tcp 4762
acbuild mount add scanroot /opt/scanroot
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- www-data
acbuild set-exec -- /bin/bash /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
