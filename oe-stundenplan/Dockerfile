FROM debian:bullseye AS base

ARG STUNDENPLAN_PATH=./oe-stundenplan

# Install normal dependencies
RUN apt-get update
RUN apt-get -y --no-install-recommends install 'g++' gcc make wget uwsgi uwsgi-plugin-python3 python3 libldap2-dev libsasl2-dev libssl-dev python3-dev python3-pip python3-setuptools nginx
RUN pip3 install wheel

# Add project code to container
ADD $STUNDENPLAN_PATH/stundenplan-backend /app/backend

# Setup backend
RUN pip3 install uWSGI
RUN pip3 install -r /app/backend/requirements.txt

FROM node:18 AS frontend

# Build frontend
ARG STUNDENPLAN_PATH=./oe-stundenplan
ADD $STUNDENPLAN_PATH/stundenplan-frontend /app/frontend
WORKDIR /app/frontend
RUN npm install
RUN npm run build

FROM base AS final
COPY --from=frontend /app/frontend/build /app/static
ADD start.sh /usr/local/bin/run
ADD uwsgi-stundenplan.ini /etc/uwsgi/stundenplan.ini
ADD nginx.conf /etc/nginx/sites-enabled/default

RUN usermod -u 2009 -g 33 -d /app/backend www-data

ENV STUNDENPLAN_STATIC=app/static

#USER www-data:www-data
CMD /usr/local/bin/run

