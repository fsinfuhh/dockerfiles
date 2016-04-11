set -e

acbuildend () {
        export EXIT=$?;
            acbuild --debug end && exit $EXIT;
}

acbuild --debug begin
trap acbuildend EXIT

