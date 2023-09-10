FROM ghcr.io/fsinfuhh/base-bullseye

RUN apt-get -y --no-install-recommends install g++ wget uwsgi uwsgi-plugin-python3 python3 python3-pip python3-six make python3-psycopg2 python3-ldap3 gettext gcc python3-dev libldap2-dev libsasl2-dev libldap-2.4-2 libsasl2-2

COPY MafiAStar /app/src

WORKDIR /app/src

ADD requirements.txt /app/src

RUN pip3 install -r requirements.txt
RUN python3 manage.py compilemessages
RUN ln -sf /app/config/settings.py /app/src/MafiAStar/settings.py

#RUN apt purge -y --auto-remove g++ wget python3-dev python3-pip make gcc libldap2-dev libsasl2-dev

COPY run /usr/local/bin
COPY uwsgi-mafiastar.ini /etc/uwsgi/mafiastar.ini

VOLUME /app/static
VOLUME /app/config
VOLUME /app/media

ENTRYPOINT /usr/local/bin/run
