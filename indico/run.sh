#!/bin/bash
nginx
uwsgi -i /etc/uwsgi/apps-enabled/indico.ini
