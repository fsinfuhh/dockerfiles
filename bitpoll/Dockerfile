#sentry-cli releases -o sentry-internal new -p bitpoll $VERSION
FROM debian:buster

ENV UID=2008

RUN usermod -u $UID -g nogroup -d /opt/bitpoll www-data
RUN apt update
RUN apt-get -y --no-install-recommends install g++ wget uwsgi uwsgi-plugin-python3 python3 python-virtualenv python3-pip virtualenv make git python3-psycopg2 python3-ldap3 gettext gcc python3-dev libldap2-dev gpg gpg-agent curl libsasl2-dev

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y --no-install-recommends npm

RUN npm install cssmin uglify-js -g

RUN wget -nv https://github.com/fsinfuhh/Bitpoll/archive/master.tar.gz -O- | tar -xzC /opt
RUN mv /opt/Bitpoll-feature_calendar /opt/bitpoll

WORKDIR /opt/bitpoll

RUN pip3 install -U pip setuptools
RUN pip3 install -r requirements-production.txt
RUN pip install requests  # for sentry
RUN ln -sf /opt/static/ /opt/bitpoll/_static
RUN cp bitpoll/settings_local.sample.py bitpoll/settings_local.py
RUN python3 manage.py compilemessages
RUN chown $UID -R _static
RUN chmod o+r -R .
RUN rm bitpoll/settings_local.py

RUN ln -sf /opt/config/settings.py /opt/bitpoll/bitpoll/settings_local.py
RUN ln -sf /opt/storage/media /opt/bitpoll/_media
RUN apt-get -y purge yui-compressor git python-pip make gcc python-dev libldap2-dev libsasl2-dev curl gpg
RUN apt-get -y autoremove
RUN apt-get clean

ARG RELEASE_VERSION=2019.12.05
RUN echo $RELEASE_VERSION > /opt/bitpoll/.releaseversion

ENV LANG=C.UTF-8
COPY run /usr/local/bin
COPY uwsgi-bitpoll.ini /etc/uwsgi/bitpoll.ini
EXPOSE 3008/tcp
VOLUME /opt/static
VOLUME /opt/config
VOLUME /opt/log

USER www-data:nogroup
ENTRYPOINT /usr/local/bin/run
