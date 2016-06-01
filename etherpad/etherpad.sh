#! /bin/bash

VERSION=2016.05.30
NAME=etherpad
IMAGE_NAME=$NAME-$VERSION-linux-amd64.aci

. ../acbuildhelper.sh

echo "Building $IMAGE_NAME"

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-system

acbuild run -- /bin/sh -es <<"EOF"
    usermod -u 2005 -g nogroup www-data
    apt-get -y --no-install-recommends install wget lsb-release apt-transport-https

    wget -nv https://deb.nodesource.com/gpgkey/nodesource.gpg.key -O- | apt-key add -
    echo 'deb https://deb.nodesource.com/node_4.x jessie main' > /etc/apt/sources.list.d/nodejs.list
    apt update
    apt -y install nodejs curl make g++
    apt-get clean

    wget -nv https://github.com/ether/etherpad-lite/tarball/master -O- | tar -C /opt -xz
    mv /opt/ether-etherpad-lite* /opt/etherpad
    chown -R www-data:nogroup /opt/etherpad

    cd /opt/etherpad
    bin/installDeps.sh
    npm install ep_adminpads ep_align ep_authornames ep_ether-o-meter  ep_headings2 ep_hide_referrer ep_latexexport ep_line_height ep_message_all ep_subscript_and_superscript
    # ep_font_size & font famely
 
    ln -sf /opt/config/settings.json /opt/etherpad/settings.json
    ln -sf /opt/config/APIKEY.txt /opt/etherpad/APIKEY.txt

    apt -y purge make g++
    apt-get -y autoremove
    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=www-data HOME=/opt/etherpad
cd /opt/etherpad
exec ./bin/safeRun.sh /opt/log/etherpad.log
EOG
    chmod +x /usr/local/bin/run

EOF
acbuild port add www tcp 9001
#acbuild mount add storage /opt/storage
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-user -- www-data
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
