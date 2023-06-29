FROM debian:bullseye

RUN apt update
RUN apt -y --no-install-recommends install python3 python3-pip python3-setuptools python3-wheel gcc make uwsgi uwsgi-plugin-python3 libldap2-dev libldap-2.4-2 libsasl2-dev libsasl2-2 python3-dev

ADD mensa-utils/requirements.txt /app/requirements.txt

RUN pip3 install django-ldapdb django-auth-ldap sentry-sdk -r /app/requirements.txt

COPY mensa-utils /app/src
RUN rm -rf /app/src/.pyenv

WORKDIR /app/src

RUN ln -sf /app/config/settings.py /app/src/mensautils/settings.py

COPY uwsgi-mensautils.ini /etc/uwsgi/mensautils.ini
COPY run /usr/local/bin/run

VOLUME /app/static
VOLUME /app/config

ENTRYPOINT /usr/local/bin/run
