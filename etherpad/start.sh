#!/bin/sh
export HOME=/opt/etherpad
cd /opt/etherpad
exec ./bin/safeRun.sh /opt/log/etherpad.log --root
