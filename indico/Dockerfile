FROM debian:buster-slim

RUN apt update
RUN apt install -y libpq-dev nginx python-dev python-pip python-virtualenv libxslt1-dev libxml2-dev libffi-dev libpcre3-dev libyaml-dev build-essential uwsgi libjpeg62-turbo-dev nginx libsasl2-dev libldap2-dev libssl-dev

RUN useradd -rm -d /opt/indico -s /bin/bash indico

RUN pip install -U pip setuptools
RUN pip install indico uWSGI python-ldap

ADD uwsgi.ini /etc/uwsgi/apps-enabled/indico.ini
ADD nginx.conf /etc/nginx/conf.d/indico.conf
ADD run.sh /usr/local/bin/run

VOLUME /opt/indico
VOLUME /opt/config

ENTRYPOINT /usr/local/bin/run
