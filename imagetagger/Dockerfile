FROM registry.mafiasi.de/base-buster

# install imagetagger system dependencies
RUN apt update && \
	apt install -y g++ wget uwsgi-plugin-python3 python3 python3-pip node-uglify make git python3-psycopg2 python3-ldap3 gettext gcc python3-dev libldap2-dev libsasl2-dev

# download latest version from github
ARG GIT_URL="https://github.com/bit-bots/imagetagger.git"
RUN git clone "$GIT_URL" /opt/imagetagger

# install python dependencies
RUN pip3 install -r /opt/imagetagger/requirements.txt && \
	pip3 install raven uwsgi django-ldapdb django-auth-ldap

# clean container
RUN apt -y purge node-uglify git python3-pip make gcc python3-dev libldap2-dev libsasl2-dev
RUN apt clean

# confiure runtime environment
ARG UID_WWW_DATA=5008
ARG GID_WWW_DATA=33
RUN usermod -u $UID_WWW_DATA -g $GID_WWW_DATA -d /opt/imagetagger www-data
RUN ln -sf /opt/config/settings.py /opt/imagetagger/imagetagger/imagetagger/settings.py
RUN chown -R www-data /opt
RUN sed -i 's/env python/env python3/g' /opt/imagetagger/imagetagger/manage.py

COPY uwsgi_imagetagger.ini /etc/uwsgi/imagetagger.ini
COPY update_points /usr/local/bin/update_points
COPY zip_daemon /usr/local/bin/zip_daemon
COPY run /usr/local/bin/run
ENTRYPOINT /usr/local/bin/run

# add image metadata
USER www-data:www-data
EXPOSE 3008
VOLUME /opt/static
VOLUME /opt/config
VOLUME /opt/storage
VOLUME /opt/log

