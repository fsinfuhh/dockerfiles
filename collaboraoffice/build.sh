#! /bin/bash

V=13
VERSION=0.0
#$(wget -qO- https://download.nextcloud.com/server/releases/ | grep -oE nextcloud-${V}[^\"]\*.tar.bz2 | sort | uniq | tail -1 | cut -d- -f2 | cut -d. -f-3)
NAME=collaboraoffice

. ../acbuildhelper.sh

acbuild set-name rkt.mafiasi.de/$NAME
acbuild dependency add rkt.mafiasi.de/base-stretch

acbuild run -- /usr/bin/env V=$V /bin/sh -es <<"EOF"
    # import the signing key
    apt-get install gnupg apt-transport-https -y
    apt-key adv --no-tty --keyserver keyserver.ubuntu.com --recv-keys 0C54D189F4BA284D 
    # add the repository URL to /etc/apt/sources.list
    echo 'deb https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-debian9 ./' >> /etc/apt/sources.list
    # perform the installation
    apt-get update && apt-get install -y loolwsd code-brand #collaboraofficebasis6.0-de
    usermod -u 2010 -g nogroup lool
    mkdir /opt/jails
    chown lool /opt/jails
    chown lool /var/cache/loolwsd
    chown -hR lool /opt/collaboraoffice6.0/
    apt-get clean


    ln -sf /opt/config/loolwsd.xml /etc/loolwsd/loolwsd.xml
    ln -s /var/log/collabora /opt/log/


    cat > /usr/local/bin/run <<EOG
#!/bin/sh
export USER=lool HOME=/opt/lool
# TODO: this is ugly
cp -r /usr/share/loolwsd/ /opt/static
#. /etc/sysconfig/loolwsd
# TODO: warum überlebt das den container ein/auspacken nicht?
export LANG=C.UTF-8
setcap "CAP_SYS_CHROOT=ep cap_mknod=ep cap_fowner=ep" /usr/bin/loolforkit
su lool -s /bin/bash -c /usr/bin/loolwsd  -- --version --o:sys_template_path=/opt/lool/systemplate --o:lo_template_path=/opt/collaboraoffice6.0 --o:child_root_path=/opt/lool/child-roots --o:file_server_root_path=/opt/storage/files
EOG
    chmod +x /usr/local/bin/run

EOF
#echo '{ "set": ["@rkt/default-whitelist"], "errno": "ENOSYS"}' | acbuild isolator add "os/linux/seccomp-retain-set" -
#echo '{ "set": [ 
#    "CAP_AUDIT_WRITE",
#    "CAP_CHOWN",
#    "CAP_DAC_OVERRIDE",
#    "CAP_FSETID",
#    "CAP_KILL",
#    "CAP_NET_RAW",
#    "CAP_NET_BIND_SERVICE",
#    "CAP_SETUID",
#    "CAP_SETGID",
#"CAP_SETPCAP",
#    "CAP_SETFCAP"
#    ] }' | acbuild isolator add "os/linux/capabilities-remove-set" -
# aus dem remove set genommen weil loolwsd die braucht
    #"CAP_SYS_CHROOT"
    #"CAP_MKNOD",
    #"CAP_FOWNER",
acbuild port add http tcp 9980
acbuild mount add storage /opt/storage
acbuild mount add config /opt/config
acbuild mount add log /opt/log
acbuild mount add static /opt/static
acbuild set-group -- nogroup
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
