FROM debian:stretch

ENV UID=2007
ENV VERSION=5.1.0

RUN useradd -u $UID -g nogroup sogo
RUN apt update
RUN apt-get --no-install-recommends -y install uwsgi memcached gnustep-make gnustep-base-runtime libgnustep-base-dev gobjc libxml2-dev libldap2-dev libssl-dev zlib1g-dev libpq-dev libmemcached-dev postgresql-client libcurl4-openssl-dev wget make libdpkg-perl libsodium-dev pkg-config libzip-dev

RUN mkdir /build
WORKDIR /build

RUN wget -q https://github.com/inverse-inc/sope/archive/SOPE-$VERSION.tar.gz -O- | tar -xz
WORKDIR /build/sope-SOPE-$VERSION
RUN ./configure --with-gnustep --disable-mysql
RUN make; make install

WORKDIR /build
RUN apt install -y git
RUN git clone https://github.com/inverse-inc/sogo
#RUN wget -q https://github.com/inverse-inc/sogo/archive/SOGo-$VERSION.tar.gz -O- | tar -xz
#WORKDIR /build/sogo-SOGo-$VERSION
WORKDIR /build/sogo
RUN git checkout SOGo-$VERSION
RUN git revert --no-commit 6aca61d8aef4f34e45b480ce3bae19318bc0e685
RUN ./configure; make; make install

WORKDIR /
RUN rm -r /build

RUN apt-get -y remove wget make
RUN apt-get clean
RUN apt-get autoclean

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
