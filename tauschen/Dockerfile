FROM debian:bookworm-slim AS base

ARG TAUSCHEN_PATH=./tauschen
ARG DIRECTORY_PATH=./directory

# Install normal dependencies
RUN apt-get update
RUN apt-get -y --no-install-recommends install 'g++' gcc make wget uwsgi uwsgi-plugin-python3 python3 libldap2-dev libsasl2-dev libssl-dev python3-dev python3-pip python3-setuptools python3-wheel
RUN pip3 install --break-system pipenv

# Clean apt
RUN apt-get -y autoremove
RUN apt-get clean

# Add project code to container
ADD $DIRECTORY_PATH /opt/directory
ADD $TAUSCHEN_PATH/tauschen-backend /opt/tauschen/tauschen-backend

# Setup backend
WORKDIR /opt/tauschen/tauschen-backend
RUN ln -sf /opt/config/settings.py /opt/tauschen/tauschen-backend/tauschen/settings.py
RUN pipenv requirements > requirements.txt
RUN pip3 install --break-system-packages /opt/directory -r requirements.txt

FROM base as frontend
ARG TAUSCHEN_PATH=./tauschen
# Install nodejs
RUN apt-get -y install npm

# Build frontend
ADD $TAUSCHEN_PATH/tauschen-frontend /opt/tauschen/tauschen-frontend
WORKDIR /opt/tauschen/tauschen-frontend
RUN npm install
RUN npm run build

FROM base as final
COPY --from=frontend /opt/tauschen/tauschen-frontend/dist/ /opt/tauschen/tauschen-frontend/dist/tauschen-frontend/
ADD start.sh /usr/local/bin/run
ADD uwsgi-tauschen.ini /etc/uwsgi/tauschen.ini

RUN usermod -u 2009 -g 33 -d /opt/tauschen/tauschen-backend www-data

VOLUME /opt/static
VOLUME /opt/config
VOLUME /opt/log
#USER www-data:www-data
CMD /usr/local/bin/run

