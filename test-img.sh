#! /bin/bash

PATH=../acbuild/bin:$PATH
echo $PATH

. acbuildhelper.sh


acbuild set-name rkt.mafiasi.de/test-nginx
acbuild dependency add rkt.mafiasi.de/base-system
acbuild run -- apt update
acbuild run -- apt install -y nginx
acbuild port add www tcp 80
acbuild set-exec -- /usr/sbin/nginx -g "daemon off;"
acbuild write test-nginx-latest-linux-amd64.aci
sudo -su nils gpg --default-key E4CA7691 --armor --output test-nginx-latest-linux-amd64.aci.asc --detach-sign test-nginx-latest-linux-amd64.aci 
