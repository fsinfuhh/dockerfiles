set -e

if [[ -z $IMAGE_NAME ]]; then
    export IMAGE_NAME=$NAME-${VERSION+$VERSION-}$(git describe --dirty --always --tags)-$(date -Is)-linux-amd64.aci
elif
    echo "Building $IMAGE_NAME"
fi

if [[ $EUID -ne 0 ]]; then
    sudo -E $0 --secret "$@"
    rm -f $IMAGE_NAME.asc
    gpg --armor --output $IMAGE_NAME.asc --detach-sign $IMAGE_NAME
    exit 0
elif [[ "$1" != --secret ]]; then
    echo Nein, Nils. Ohne sudo.
    exit 1
fi
shift

T=$(mktemp -d ${TMPDIR-/tmp}/acbuild.XXXXXX)
acbuild () {
    command acbuild --work-path $T --debug $@
}

acbuildend () {
    export EXIT=$?;
    acbuild end
    rmdir $T >/dev/null || :
    exit $EXIT;
}

acbuild begin
trap acbuildend EXIT
