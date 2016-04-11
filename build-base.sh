#! /bin/bash

. acbuildhelper.sh


debootstrap jessie .acbuild/currentaci/rootfs
acbuild set-name rkt.mafiasi.de/base-system
acbuild run -- apt install -y vim
acbuild set-exec -- /bin/bash
acbuild write base-system.aci
