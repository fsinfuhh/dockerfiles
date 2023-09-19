FROM debian:bullseye-slim

RUN apt install -y --no-install-recommends \
    wget \
    php7.4 \
    php7.4-fpm \
    php7.4-gd \
    php7.4-imap \
    php7.4-ldap \
    php7.4-mbstring \
    php7.4-pdo-pgsql \
    php7.4-xml \
    php7.4-zip \
    nginx \
    unzip

RUN mkdir -p /var/www /run/php

WORKDIR /var/www

ARG LIMESURVEY_RELEASE=https://download.limesurvey.org/latest-stable-release/limesurvey5.4.0+220913.zip
RUN wget $LIMESURVEY_RELEASE -O limesurvey.zip
RUN unzip limesurvey.zip
RUN rm -rf limesurvey/upload

RUN mkdir -p /app/config /app/upload
RUN ln -sf /app/config/config.php /var/www/limesurvey/application/config/config.php
RUN ln -sf /app/config/security.php /var/www/limesurvey/application/config/security.php
RUN ln -sf /app/upload /var/www/limesurvey/upload
RUN chmod o+w /var/www/limesurvey/application/config

COPY nginx.conf /etc/nginx/sites-enabled/limesurvey.conf
COPY www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY run.sh /usr/local/bin/run

VOLUME /app/config
VOLUME /app/upload

ENTRYPOINT /usr/local/bin/run
