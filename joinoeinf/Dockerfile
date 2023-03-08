FROM docker.io/debian:bullseye

RUN apt update
RUN apt -y --no-install-recommends install python3 python3-pip python3-setuptools python3-wheel build-essential libldap2-dev python3-dev libsasl2-dev libpython3.9

COPY join.oeinf.de /opt/joinoeinf
RUN usermod -u 101 -g 33 -d /opt/joinoeinf www-data

WORKDIR /opt/joinoeinf

RUN pip3 install -r requirements.txt
RUN pip3 install uwsgi psycopg2-binary==2.9.5

RUN ln -sf /opt/config/settings.py /opt/joinoeinf/join_oeinf/settings.py
RUN ln -sf /opt/static/ /opt/joinoeinf/static

RUN chown -R www-data:www-data .

RUN apt remove -y --autoremove python3-pip python3-setuptools python3-wheel python3-dev libsasl2-dev

COPY uwsgi-joinoeinf.ini /etc/uwsgi/joinoeinf.ini
COPY run /usr/local/bin/run

VOLUME /opt/static
VOLUME /opt/config

USER www-data:www-data

ENTRYPOINT /usr/local/bin/run
