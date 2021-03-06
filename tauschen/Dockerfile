FROM debian:buster AS base

ARG TAUSCHEN_PATH=./tauschen
ARG DIRECTORY_PATH=./directory

# Install normal dependencies
RUN apt-get update
RUN apt-get -y --no-install-recommends install 'g++' gcc make wget uwsgi uwsgi-plugin-python3 python3 libldap2-dev libsasl2-dev libssl-dev python3-dev python3-pip python3-setuptools
RUN pip3 install wheel

# Clean apt
RUN apt-get -y autoremove
RUN apt-get clean

# Add project code to container
ADD $DIRECTORY_PATH /opt/directory
ADD $TAUSCHEN_PATH/tauschen-backend /opt/tauschen/tauschen-backend

# Setup backend
RUN pip3 install sentry-sdk uWSGI
RUN pip3 install -r /opt/tauschen/tauschen-backend/requirements.txt
RUN ln -sf /opt/config/settings.py /opt/tauschen/tauschen-backend/tauschen/settings.py
RUN pip3 install /opt/directory

FROM base as frontend
ARG TAUSCHEN_PATH=./tauschen
# Install nodejs
RUN apt-get -y install npm
RUN yes no | npm install yarn @angular/cli --global

# Build frontend
ADD $TAUSCHEN_PATH/tauschen-frontend /opt/tauschen/tauschen-frontend
WORKDIR /opt/tauschen/tauschen-frontend
RUN yarn install
RUN ng build --prod --subresource-integrity --optimization --aot --source-map

FROM base as final
COPY --from=frontend /opt/tauschen/tauschen-frontend/dist/tauschen-frontend/ /opt/tauschen/tauschen-frontend/dist/tauschen-frontend/
ADD start.sh /usr/local/bin/run
ADD uwsgi-tauschen.ini /etc/uwsgi/tauschen.ini

RUN usermod -u 2009 -g 33 -d /opt/tauschen/tauschen-backend www-data

VOLUME /opt/static
VOLUME /opt/config
VOLUME /opt/log
#USER www-data:www-data
CMD /usr/local/bin/run

