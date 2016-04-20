#! /bin/bash

IMAGE_NAME=test-nginx-latest-linux-amd64.aci
. acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/test-nginx
acbuild dependency add rkt.mafiasi.de/base-system
acbuild run -- apt update
acbuild run -- apt install -y nginx
acbuild port add www tcp 80
acbuild set-exec -- /usr/sbin/nginx -g "daemon off;"
acbuild write --overwrite $IMAGE_NAME
