FROM registry.mafiasi.de/base-buster

RUN apt install -y --no-install-recommends \
    wget \
    php7.3 \
    php7.3-fpm \
    php7.3-gd \
    php7.3-imap \
    php7.3-ldap \
    php7.3-mbstring \
    php7.3-pdo-pgsql \
    php7.3-xml \
    php7.3-zip \
    nginx \
    unzip

RUN mkdir -p /var/www /run/php

WORKDIR /var/www

RUN wget https://download.limesurvey.org/latest-stable-release/limesurvey4.3.14+200826.zip -O limesurvey.zip
RUN unzip limesurvey.zip
RUN rm -rf limesurvey/upload

RUN mkdir -p /app/config /app/upload
RUN ln -sf /app/config/config.php /var/www/limesurvey/application/config/config.php
RUN ln -sf /app/config/security.php /var/www/limesurvey/application/config/security.php
RUN ln -sf /app/upload /var/www/limesurvey/upload

COPY nginx.conf /etc/nginx/sites-enabled/limesurvey.conf
COPY www.conf /etc/php/7.3/fpm/pool.d/www.conf
COPY run.sh /usr/local/bin/run

VOLUME /app/config
VOLUME /app/upload

ENTRYPOINT /usr/local/bin/run
