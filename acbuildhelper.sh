set -e

if [[ $EUID -ne 0 ]]; then
    sudo $0 --secret "$@"
    rm -f $IMAGE_NAME.asc
    gpg --armor --output $IMAGE_NAME.asc --detach-sign $IMAGE_NAME
    exit 0
elif [[ "$1" != --secret ]]; then
    echo Nein, Nils. Ohne sudo.
    exit 1
fi
shift

acbuild () {
    command acbuild --debug $@
}

acbuildend () {
    export EXIT=$?;
    acbuild end && exit $EXIT;
}

acbuild begin
trap acbuildend EXIT
