FROM registry.mafiasi.de/base-buster

RUN usermod -u 2013 -g 33 -d /opt/familiendoell www-data; \
    apt-get -y --no-install-recommends install g++ wget uwsgi uwsgi-plugin-python uwsgi-plugin-python3 python python-virtualenv python3-pip virtualenv node-uglify make git python3-psycopg2 python3-ldap3 gettext gcc python3-dev libldap2-dev libsasl2-dev

COPY familiendOEll-auswerter /opt/familiendoell

WORKDIR /opt/familiendoell
RUN pip3 install -r requirements.txt; \
    pip3 install setuptools wheel; \
    pip3 install psycopg2 django-ldapdb django-auth-ldap uwsgi raven requests

RUN ln -sf /opt/config/settings.py /opt/familiendoell/familiendoellauswerter/familiendoellauswerter; \
    ln -sf /opt/config/settings.py /opt/familiendoell/familiendoellauswerter/familiendoellauswerter/settings.py; \
    ln -sf /opt/storage/static/ /opt/familiendoell/familiendoellauswerter/_static

RUN apt-get -y purge node-uglify git python-pip make gcc python-dev libldap2-dev libsasl2-dev; \
    apt-get -y autoremove; \
    apt-get clean

COPY run /usr/local/bin/run
COPY uwsgi-familiendoell.ini /etc/uwsgi/familiendoell.ini
EXPOSE 3008
VOLUME /opt/static /opt/config /opt/storage
USER www-data:www-data
ENTRYPOINT /usr/local/bin/run
