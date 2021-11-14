FROM registry.mafiasi.de/base-bullseye
ARG VERSION=21.0.5
ARG UID=3001
ARG GID=3001

RUN groupmod -g $GID www-data
RUN usermod -u $UID -g $GID -d /var/www/ www-data

RUN apt-get -y --no-install-recommends install \
        nginx \
        wget \
        php7.4 \
        php7.4-apcu \
        php7.4-curl \
        php7.4-fpm \
        php7.4-gd \
        php7.4-intl \
        php7.4-json \
        php7.4-ldap \
        php7.4-mbstring \
        php7.4-memcache \
        php7.4-pgsql \
        php7.4-redis \
        php7.4-xml \
        php7.4-zip \
        php7.4-bcmath \
        php7.4-gmp \
        strace \
        bzip2 \
        git \
        php-imagick; \
    mkdir /var/www ; \
    wget -qO- https://download.nextcloud.com/server/releases/nextcloud-${VERSION}.tar.bz2 | \
    tar -C /var/www -xj --no-same-owner; \
    chown -R www-data /var/www/nextcloud/apps; \
    chown -R www-data /var/www/nextcloud/config

# install richdocuments
ARG RICHDOCUMENTS_VERSION=v4.1.2
RUN wget -qO- https://github.com/nextcloud/richdocuments/releases/download/${RICHDOCUMENTS_VERSION}/richdocuments.tar.gz |\
    tar -C /var/www/nextcloud/apps -xz --no-same-owner

# install deck app
ARG DECK_VERSION=v1.4.7
RUN wget -qO- https://github.com/nextcloud/deck/releases/download/${DECK_VERSION}/deck.tar.gz |\
    tar -C /var/www/nextcloud/apps -xz --no-same-owner

RUN ln -sf /opt/config/nginx.conf /etc/nginx/sites-enabled/default; \
    ln -sf /opt/config/www.conf /etc/php/7.4/fpm/pool.d/www.conf; \
    ln -s /var/log/php7.4-fpm.log /opt/log/php7.4-fpm.error.log; \
    { echo 'opcache.enable=1'; \
      echo 'opcache.enable_cli=1'; \
      echo 'opcache.interned_strings_buffer=8'; \
      echo 'opcache.max_accelerated_files=10000'; \
      echo 'opcache.memory_consumption=128'; \
      echo 'opcache.save_comments=1'; \
      echo 'opcache.revalidate_freq=1'; \
    } >> /etc/php/7.4/fpm/php.ini; \
    echo 'apc.enable_cli=1' >> /etc/php/7.4/mods-available/apcu.ini; \
    sed -i "s/memory_limit = 128M/memory_limit = 512M/" /etc/php/7.4/fpm/php.ini

RUN chown www-data /opt/config

RUN apt-get purge git* --yes --auto-remove; \
    apt-get clean

#USER www-data:nogroup
ADD start.sh /usr/local/bin/run
VOLUME /opt/storage /opt/config /opt/log /opt/static
EXPOSE 9787/tcp
ENTRYPOINT /usr/local/bin/run
