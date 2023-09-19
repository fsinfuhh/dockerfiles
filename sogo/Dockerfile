FROM debian:bullseye-slim

ENV UID=2007
ENV VERSION=5.8.2

RUN useradd -u $UID -g nogroup sogo
RUN apt update
RUN apt-get --no-install-recommends -y install uwsgi memcached gnustep-make gnustep-base-runtime libgnustep-base-dev gobjc libxml2-dev libldap2-dev libssl-dev zlib1g-dev libpq-dev libmemcached-dev postgresql-client libcurl4-openssl-dev wget make libdpkg-perl libsodium-dev pkg-config libzip-dev libytnef-dev patch

RUN mkdir /build && cd /build && \
    wget -q https://github.com/inverse-inc/sope/archive/SOPE-$VERSION.tar.gz -O- | tar -xz && \
    cd /build/sope-SOPE-$VERSION && \
    ./configure --with-gnustep --disable-mysql && \
    make && make install

ADD ldap_fix.patch /
RUN cd /build && \
    wget -q https://github.com/inverse-inc/sogo/archive/SOGo-$VERSION.tar.gz -O- | tar -xz && \
    cd sogo-SOGo-$VERSION && \
    patch -p1 < /ldap_fix.patch && \
    ./configure && make && make install && \
    cd / && \
    rm -rf /build || rm -rf /build  # Sometimes, first rm fails for unknown reasons

RUN install -o sogo -g nogroup -m 750 -d /var/spool/sogo /etc/sogo
RUN ln -sf /opt/config/sogo.conf /etc/sogo/sogo.conf
RUN echo /usr/local/lib > /etc/ld.so.conf.d/sogo.conf
RUN echo /usr/local/lib/sogo > /etc/ld.so.conf.d/sogo.conf
RUN ldconfig

RUN echo ".sg-event--cancelled{display: none !important;}" >> /usr/local/lib/GNUstep/SOGo/WebServerResources/css/theme-default.css

COPY run /usr/local/bin/run
COPY stop /usr/local/bin/stop
COPY uwsgi-sogo.ini /etc/uwsgi/sogo.ini

EXPOSE 3007/tcp
VOLUME /opt/static /opt/config /opt/log
ENTRYPOINT /usr/local/bin/run
