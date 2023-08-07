FROM debian:bullseye AS base

ARG BACKEND_PATH=./MafiAStarLite

# Install normal dependencies
RUN apt-get update
RUN apt-get -y --no-install-recommends install uwsgi uwsgi-plugin-python3 python3 python3-pip python3-setuptools pipenv nginx
RUN pip3 install wheel

# Add project code to container
ADD $BACKEND_PATH /app/backend

# Setup backend
RUN cd /app/backend && pipenv install --system --deploy --ignore-pipfile

FROM node:18 AS frontend

# Build frontend
ARG FRONTEND_PATH=./MafiAStarLite-frontend
ADD $FRONTEND_PATH /app/frontend
WORKDIR /app/frontend
RUN npm install
RUN npm run build

FROM base AS final
COPY --from=frontend /app/frontend/dist /app/static
RUN mkdir /app/backend/logs
ADD start.sh /usr/local/bin/run
ADD uwsgi-mafiastar.ini /etc/uwsgi/mafiastar.ini
ADD nginx.conf /etc/nginx/sites-enabled/default

RUN usermod -u 2009 -g 33 -d /app/backend www-data

CMD /usr/local/bin/run
