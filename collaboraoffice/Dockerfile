FROM registry.mafiasi.de/base-buster

# add collaboraoffice repository
RUN apt update && \
	apt install -y gnupg
RUN apt-key adv --no-tty --keyserver keyserver.ubuntu.com --recv-keys 0C54D189F4BA284D
COPY collabora_online.sources.list /etc/apt/sources.list.d/collabora_online.list

# install collaboraoffice
RUN apt update && \
	apt install -y loolwsd code-brand

# clean image
RUN apt clean

# configure runtime
ARG UID_LOOL=2010
RUN mkdir /opt/jails
RUN usermod -u $UID_LOOL -g nogroup lool && \
	chown lool /opt/jails && \
	chown lool /var/cache/loolwsd && \
	chown -hR lool /opt/collaboraoffice*/
RUN ln -sf /opt/config/loolwsd.xml /etc/loolwsd/loolwsd.xml && \
	ln -sf /var/log/collabora /opt/log

ARG LANG=C.UTF-8
ENV LANG=$LANG

WORKDIR /opt/lool

# add start-script
COPY run /usr/local/bin/
ENTRYPOINT /usr/local/bin/run

# configure image metadata
EXPOSE 9980/tcp
VOLUME /opt/storage
VOLUME /opt/config
VOLUME /opt/log
VOLUME /opt/static

