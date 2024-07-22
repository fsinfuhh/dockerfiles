FROM debian:bookworm-slim
ARG VERSION=29.0.3
ARG UID=3001
ARG GID=3001

RUN groupmod -g $GID www-data
RUN usermod -u $UID -g $GID -d /var/www/ www-data

RUN apt-get update; \
    apt-get -y --no-install-recommends install \
        vim \
        ca-certificates \
        nginx \
        wget \
        patch \
        php8.2 \
        php8.2-apcu \
        php8.2-curl \
        php8.2-fpm \
        php8.2-gd \
        php8.2-intl \
        php-json \
        php8.2-ldap \
        php8.2-mbstring \
        php8.2-memcache \
        php8.2-pgsql \
        php8.2-redis \
        php8.2-xml \
        php8.2-zip \
        php8.2-bcmath \
        php8.2-gmp \
        strace \
        bzip2 \
        php-imagick; \
    mkdir -p /var/www /opt/config /opt/static /opt/log; \
    wget -qO- https://download.nextcloud.com/server/releases/nextcloud-${VERSION}.tar.bz2 | \
    tar -C /var/www -xj --no-same-owner; \
    chown -R www-data /var/www/nextcloud/apps; \
    chown -R www-data /var/www/nextcloud/config

# disable nextcloud message about unsupported notifications (because we have more than 5000 users)
ADD disable_notification_message.patch /tmp/disable_notification_message.patch
RUN patch -p1 -d /var/www/nextcloud < /tmp/disable_notification_message.patch

# install richdocuments
ARG RICHDOCUMENTS_VERSION=v8.2.4
RUN mkdir /var/www/nextcloud/apps/richdocuments && \
    wget -qO- https://github.com/nextcloud/richdocuments/archive/refs/tags/${RICHDOCUMENTS_VERSION}.tar.gz |\
    tar -C /var/www/nextcloud/apps/richdocuments --strip-components 1 -xz --no-same-owner

# install deck app
ARG DECK_VERSION=v1.11.3
RUN wget -qO- https://github.com/nextcloud/deck/releases/download/${DECK_VERSION}/deck.tar.gz |\
    tar -C /var/www/nextcloud/apps -xz --no-same-owner

# install oidc login
ARG OIDC_VERSION=v3.0.2
RUN wget -qO- https://github.com/pulsejet/nextcloud-oidc-login/releases/download/${OIDC_VERSION}/oidc_login.tar.gz |\
    tar -C /var/www/nextcloud/apps -xz --no-same-owner

RUN ln -sf /opt/config/nginx.conf /etc/nginx/sites-enabled/default; \
    ln -sf /opt/config/www.conf /etc/php/8.2/fpm/pool.d/www.conf; \
    ln -s /var/log/php8.2-fpm.log /opt/log/php8.2-fpm.error.log; \
    { echo 'opcache.enable=1'; \
      echo 'opcache.enable_cli=1'; \
      echo 'opcache.interned_strings_buffer=8'; \
      echo 'opcache.max_accelerated_files=10000'; \
      echo 'opcache.memory_consumption=128'; \
      echo 'opcache.save_comments=1'; \
      echo 'opcache.revalidate_freq=1'; \
    } >> /etc/php/8.2/fpm/php.ini; \
    echo 'apc.enable_cli=1' >> /etc/php/8.2/mods-available/apcu.ini; \
    sed -i "s/memory_limit = 128M/memory_limit = 512M/" /etc/php/8.2/fpm/php.ini

RUN chown www-data /opt/config

ADD start.sh /usr/local/bin/run
VOLUME /opt/storage /opt/config /opt/log /opt/static
EXPOSE 9787/tcp
ENTRYPOINT /usr/local/bin/run
