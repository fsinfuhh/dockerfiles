FROM debian:buster

RUN apt update
RUN apt -y --no-install-recommends install g++ wget uwsgi uwsgi-plugin-python uwsgi-plugin-python3 python python-virtualenv python3-pip virtualenv yui-compressor make git python3-psycopg2 python3-ldap3 gettext gcc python3-dev libldap2-dev libsasl2-dev

RUN git clone https://github.com/bit-bots/karma.git /opt/karma
RUN usermod -u 2012 -g 33 -d /opt/karma www-data

WORKDIR /opt/karma

RUN pip3 install pipenv
ENV PIPENV_VENV_IN_PROJECT=1
RUN pipenv sync
RUN pipenv install psycopg2-binary django-ldapdb django-auth-ldap uwsgi raven requests

RUN ln -sf /opt/config/settings.py /opt/karma/karma/settings.py
RUN ln -sf /opt/storage/static/ /opt/karma/_static
RUN ln -sf /opt/storage/media /opt/karma/_media

COPY uwsgi-karma.ini /etc/uwsgi/karma.ini
COPY run /usr/local/bin/run

VOLUME /opt/static
VOLUME /opt/config
VOLUME /opt/storage

USER www-data:www-data

ENTRYPOINT /usr/local/bin/run
