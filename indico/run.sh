#!/bin/bash
nginx
su - indico -c "indico db upgrade"
su - indico -c "indico db --all-plugins upgrade"
uwsgi -i /etc/uwsgi/apps-enabled/indico.ini
