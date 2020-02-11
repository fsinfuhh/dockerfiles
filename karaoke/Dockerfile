FROM registry.mafiasi.de/base-buster

ENV UID=2008

RUN usermod -u $UID -g nogroup -d /opt/MafiAStar www-data
RUN apt update

# https://stackoverflow.com/questions/58160597/docker-fails-with-sub-process-usr-bin-dpkg-returned-an-error-code-1
RUN mkdir -p /usr/share/man/man1 

RUN apt-get -y --no-install-recommends install g++ wget uwsgi uwsgi-plugin-python python python-virtualenv python3-pip yui-compressor make git python3-psycopg2 python3-ldap3 gettext gcc python3-dev libldap2-dev libsasl2-dev coffeescript ruby-sass

COPY MafiAStar /opt/MafiAStar

WORKDIR /opt/MafiAStar

RUN pip3 install -U pip setuptools
RUN pip3 install -r requirements.txt
RUN pip3 install -U 'Django<1.12' django-ldapdb django-auth-ldap uwsgi raven

RUN python3 manage.py compilemessages

RUN ln -sf /opt/config/settings.py /opt/MafiAStar/MafiAStar/settings.py
RUN ln -sf /opt/storage/media /opt/MafiAStar/_media
RUN apt-get -y purge yui-compressor git python-pip make gcc python3-dev libldap2-dev libsasl2-dev; \
    apt-get -y autoremove; \
    apt-get clean

COPY run /usr/local/bin
COPY uwsgi-mafiastar.ini /etc/uwsgi/mafiastar.ini
EXPOSE 3008/tcp

VOLUME /opt/static
VOLUME /opt/config
VOLUME /opt/log

USER www-data:nogroup
ENTRYPOINT /usr/local/bin/run
