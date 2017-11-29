#! /bin/bash
VERSION=`curl -s https://packages.debian.org/stretch/amd64/slapd/download | grep -oE "slapd_.*?\.deb" | head -n 1 | sed "s/^slapd_//" | sed "s/_amd64.deb$//"`
NAME=slapd

. ../acbuildhelper.sh

acbuild set-name rkt.pwsrv.de/$NAME
acbuild dependency add rkt.pwsrv.de/base
#acbuild copy modules /modules

acbuild run -- /usr/bin/env VERSION=$VERSION /bin/sh -es <<"EOF"
    apt update
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends slapd=${VERSION} dialog

    mv /etc/ldap /etc/ldap.dist
    #mv /modules /etc/ldap.dist/

    cat > /usr/local/bin/run <<"EOG"
#!/bin/bash
#
## When not limiting the open file descritors limit, the memory consumption of
## slapd is absurdly high. See https://github.com/docker/docker/issues/8231
##ulimit -n 8192
#
#set -e
#
#first_run=true
#
#if [[ -f "/var/lib/ldap/DB_CONFIG" ]]; then 
#    first_run=false
#fi
#
#if [[ ! -d /etc/ldap/slapd.d ]]; then
#
#  # get init config data from files
#  SLAPD_DOMAIN=`cat /etc/ldap/init_domain`
#  SLAPD_PASSWORD=`cat /etc/ldap/init_password`
#
#    SLAPD_ORGANIZATION="${SLAPD_ORGANIZATION:-${SLAPD_DOMAIN}}"
#
#    cp -r /etc/ldap.dist/* /etc/ldap
#
#    cat <<-CONTENT | debconf-set-selections
#        slapd slapd/no_configuration boolean false
#        slapd slapd/password1 password $SLAPD_PASSWORD
#        slapd slapd/password2 password $SLAPD_PASSWORD
#        slapd shared/organization string $SLAPD_ORGANIZATION
#        slapd slapd/domain string $SLAPD_DOMAIN
#        slapd slapd/backend select HDB
#        slapd slapd/allow_ldap_v2 boolean false
#        slapd slapd/purge_database boolean false
#        slapd slapd/move_old_database boolean true
#CONTENT
#
#    dpkg-reconfigure -f noninteractive slapd # >/dev/null 2>&1
#
#    dc_string=""
#
#    IFS="."; declare -a dc_parts=($SLAPD_DOMAIN); unset IFS
#
#    for dc_part in "${dc_parts[@]}"; do
#        dc_string="$dc_string,dc=$dc_part"
#    done
#
#    base_string="BASE ${dc_string:1}"
#
#    sed -i "s/^#BASE.*/${base_string}/g" /etc/ldap/ldap.conf
#
#    if [[ -n "$SLAPD_CONFIG_PASSWORD" ]]; then
#        password_hash=`slappasswd -s "${SLAPD_CONFIG_PASSWORD}"`
#
#        sed_safe_password_hash=${password_hash//\//\\\/}
#
#        slapcat -n0 -F /etc/ldap/slapd.d -l /tmp/config.ldif
#        sed -i "s/\(olcRootDN: cn=admin,cn=config\)/\1\nolcRootPW: ${sed_safe_password_hash}/g" /tmp/config.ldif
#        rm -rf /etc/ldap/slapd.d/*
#        slapadd -n0 -F /etc/ldap/slapd.d -l /tmp/config.ldif
#        rm /tmp/config.ldif
#    fi
#
##    if [[ -n "$SLAPD_ADDITIONAL_SCHEMAS" ]]; then
##        IFS=","; declare -a schemas=($SLAPD_ADDITIONAL_SCHEMAS); unset IFS
##
##        for schema in "${schemas[@]}"; do
##            slapadd -n0 -F /etc/ldap/slapd.d -l "/etc/ldap/schema/${schema}.ldif"
##        done
##    fi
#
#    if [[ -n "$SLAPD_ADDITIONAL_MODULES" ]]; then
#        IFS=","; declare -a modules=($SLAPD_ADDITIONAL_MODULES); unset IFS
#
#        for module in "${modules[@]}"; do
#             module_file="/etc/ldap/modules/${module}.ldif"
#
#             if [ "$module" == 'ppolicy' ]; then
#                 SLAPD_PPOLICY_DN_PREFIX="${SLAPD_PPOLICY_DN_PREFIX:-cn=default,ou=policies}"
#
#                 sed -i "s/\(olcPPolicyDefault: \)PPOLICY_DN/\1${SLAPD_PPOLICY_DN_PREFIX}$dc_string/g" $module_file
#             fi
#
#             slapadd -n0 -F /etc/ldap/slapd.d -l "$module_file"
#        done
#    fi
#
#    chown -R openldap:openldap /etc/ldap/slapd.d/
#fi

#if [[ "$first_run" == "true" ]]; then
#    if [[ -d "/etc/ldap/prepopulate" ]]; then 
#        for file in `ls /etc/ldap/prepopulate/*.ldif`; do
#            slapadd -F /etc/ldap/slapd.d -l "$file"
#        done
#    fi
#fi

mkdir /var/run/slapd
chown -R openldap:openldap /var/lib/ldap/ /var/run/slapd/

slapd -d 32768 -u openldap -g openldap
EOG
    chmod +x /usr/local/bin/run
EOF

acbuild mount add data /var/lib/ldap
acbuild mount add config /etc/ldap
acbuild mount add log /opt/log
acbuild set-user -- root
acbuild set-group -- root
acbuild set-exec -- /usr/local/bin/run

acbuild write --overwrite $IMAGE_NAME
