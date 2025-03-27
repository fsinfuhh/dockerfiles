FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y --no-install-recommends \
    ca-certificates \
    wget \
    php8.2 \
    php8.2-fpm \
    php8.2-gd \
    php8.2-imap \
    php8.2-ldap \
    php8.2-mbstring \
    php8.2-pdo-pgsql \
    php8.2-xml \
    php8.2-zip \
    nginx \
    unzip

RUN mkdir -p /var/www /run/php

WORKDIR /var/www

# Get download URL here: https://community.limesurvey.org/downloads/
ARG LIMESURVEY_RELEASE=https://download.limesurvey.org/latest-master/limesurvey6.12.2+250324.zip
RUN wget $LIMESURVEY_RELEASE -O limesurvey.zip
RUN unzip limesurvey.zip
RUN rm -rf limesurvey/upload

RUN mkdir -p /app/config /app/upload /opt/log/
RUN touch /opt/log/limesurvey.log.slow
RUN ln -sf /app/config/config.php /var/www/limesurvey/application/config/config.php
RUN ln -sf /app/config/security.php /var/www/limesurvey/application/config/security.php
RUN ln -sf /app/upload /var/www/limesurvey/upload
RUN chmod o+w /var/www/limesurvey/application/config

COPY nginx.conf /etc/nginx/sites-enabled/default
COPY www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY run.sh /usr/local/bin/run

VOLUME /app/config
VOLUME /app/upload

ENTRYPOINT /usr/local/bin/run
