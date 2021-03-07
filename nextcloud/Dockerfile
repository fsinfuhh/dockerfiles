FROM registry.mafiasi.de/base-buster
ARG VERSION=20.0.8
ARG UID=3001
ARG GID=3001

RUN groupmod -g $GID www-data
RUN usermod -u $UID -g $GID -d /var/www/ www-data

RUN apt-get -y --no-install-recommends install \
	    wget \
	    php7.3-fpm \
	    php7.3 \
	    php7.3-gd \
	    php7.3-intl \
	    php7.3-pgsql \
	    php7.3-apcu \
	    php7.3-curl \
	    php7.3-memcache \
	    php7.3-redis \
	    php7.3-ldap \
	    php7.3-xml \
	    php7.3-zip \
	    php7.3-json \
	    php7.3-mbstring \
	    strace \
	    bzip2 \
	    git \
	    php-imagick; \
    mkdir /var/www ; \
    wget -qO- https://download.nextcloud.com/server/releases/nextcloud-${VERSION}.tar.bz2 | \
    tar -C /var/www -xjv --no-same-owner; \
    chown -R www-data /var/www/nextcloud/apps; \
    chown -R www-data /var/www/nextcloud/config

# install richdocuments
ARG RICHDOCUMENTS_VERSION=v4.0.1
RUN wget -qO- https://github.com/nextcloud/richdocuments/releases/download/${RICHDOCUMENTS_VERSION}/richdocuments.tar.gz |\
    tar -C /var/www/nextcloud/apps -xzv --no-same-owner

RUN ln -sf /opt/config/config.php /var/www/nextcloud/config/config.php; \
    ln -sf /opt/config/www.conf /etc/php/7.3/fpm/pool.d/www.conf; \
    ln -s /var/log/php7.3-fpm.log /opt/log/php7.3-fpm.error.log; \
    { echo 'opcache.enable=1'; \
      echo 'opcache.enable_cli=1'; \
      echo 'opcache.interned_strings_buffer=8'; \
      echo 'opcache.max_accelerated_files=10000'; \
      echo 'opcache.memory_consumption=128'; \
      echo 'opcache.save_comments=1'; \
      echo 'opcache.revalidate_freq=1'; \
    } >> /etc/php/7.3/fpm/php.ini; \
    sed -i "s/memory_limit = 128M/memory_limit = 512M/" /etc/php/7.3/fpm/php.ini

RUN chown www-data /opt/config

RUN apt-get purge git* --yes --auto-remove; \
    apt-get clean

#USER www-data:nogroup
ADD start.sh /usr/local/bin/run
VOLUME /opt/storage /opt/config /opt/log /opt/static
EXPOSE 9787/tcp
ENTRYPOINT /usr/local/bin/run
