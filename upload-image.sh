#!/bin/bash -e

for ARG; do
    if [[ ! -f $ARG ]]; then
        echo "File $ARG does not exist"
        exit 1
    fi
    if [[ ! $ARG =~ \.aci$ ]]; then
        echo "$ARG is not an ACI-Image"
        exit 1
    fi
    if [[ ! -f ${ARG}.asc ]]; then
        echo "Image signature ${ARG}.asc is missing"
        exit 1
    fi
    BASENAME=$(basename $ARG)
    LATEST=$(sed -r 's,^(.*)-(.*)((-[^-]+){2}\..+)$,\1-latest\3,' <<< $BASENAME)
    sftp -b - fs4:/srv/data/rkt.mafiasi.de/images/rkt.mafiasi.de <<EOF
progress
put $ARG
put ${ARG}.asc 
-rm $LATEST
-rm ${LATEST}.asc
symlink $BASENAME $LATEST
symlink ${BASENAME}.asc ${LATEST}.asc
EOF
done
