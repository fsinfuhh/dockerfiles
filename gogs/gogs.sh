#! /bin/bash

VERSION=$(wget -qO- https://raw.githubusercontent.com/gogits/gogs/master/README.md | grep "Current tip version" | grep -oE "[0-9]+(\.[0-9]+)*")
NAME=gogs

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base

acbuild run -- /bin/sh -es <<"EOF"
    adduser --disabled-login --gecos 'Gogs' --uid 2001 --ingroup nogroup gogs
    echo deb http://ftp.de.debian.org/debian jessie-backports main >> /etc/apt/sources.list
    apt update
    apt-get --no-install-recommends -y install golang/jessie-backports golang-go/jessie-backports golang-src/jessie-backports golang-doc/jessie-backports git openssl ca-certificates openssh-client openssh-server

    su -c 'sh -s' gogs <<"EOG"
    cd
    export GOPATH=$HOME/go
    mkdir go
    go get -u github.com/gogits/gogs
    cd $GOPATH/src/github.com/gogits/gogs
    go build
EOG
    apt -y purge golang golang-doc golang-go golang-src
    apt-get -y autoremove
    apt-get clean

    mkdir /opt/gogs
    cp -ra /home/gogs/go/src/github.com/gogits/gogs /opt
    chown -R root:nogroup /opt/gogs
    mkdir -p /opt/gogs/custom/conf
    ln -sf /opt/config/app.ini /opt/gogs/custom/conf/
    usermod -d /opt/storage/gituser gogs
    rm -r /home/gogs
    echo "AcceptEnv SSH_ORIGINAL_COMMAND" >> /etc/ssh/sshd_config
    
    cat > /usr/local/bin/run <<EOG
#!/bin/sh
if grep -i "START_SSH_SERVER *= *false" /opt/config/app.ini; then
    echo AuthorizedKeysFile .ssh/id_ed25519.pub >> /etc/ssh/sshd_config
    service ssh start
fi

export USER=gogs HOME=/home/gogs
exec su -c 'hostname -I > /opt/storage/gogs.ip; /opt/gogs/gogs web' gogs
EOG
    chmod +x /usr/local/bin/run

EOF
acbuild port add web tcp 3005
acbuild port add ssh tcp 3006
acbuild mount add storage /opt/storage
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
