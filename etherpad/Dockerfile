FROM registry.mafiasi.de/base-buster

ENV VERSION=1.8.4

RUN apt-get --yes --no-install-recommends install wget \
						  lsb-release \
						  apt-transport-https \
						  gnupg2 ; \
     wget -nv https://deb.nodesource.com/gpgkey/nodesource.gpg.key -O- | apt-key add - ; \
     echo 'deb https://deb.nodesource.com/node_10.x buster main' > /etc/apt/sources.list.d/nodejs.list ; \
     apt update && apt --yes install nodejs curl make g++; \
     wget -nv https://github.com/ether/etherpad-lite/archive/$VERSION.tar.gz -O- | tar -C /opt -xz ; \
     mv /opt/etherpad-lite-$VERSION /opt/etherpad; \
     chown -R www-data:nogroup /opt/etherpad

WORKDIR /opt/etherpad
RUN bin/installDeps.sh; \
    npm install ep_adminpads \
		ep_align \
		ep_authornames \
		ep_ether-o-meter \
		ep_headings2 \
		ep_hide_referrer \
		ep_latexexport \
		ep_line_height \
		ep_message_all \
		ep_subscript_and_superscript; \
     ln -sf /opt/config/settings.json /opt/etherpad/settings.json ; \
     ln -sf /opt/config/APIKEY.txt /opt/etherpad/APIKEY.txt ;

RUN apt-get clean && apt --yes purge make g++ && apt-get --yes autoremove

ADD start.sh /usr/local/bin/run

VOLUME /opt/config /opt/log
EXPOSE 9001/tcp
USER root:nogroup
ENTRYPOINT /usr/local/bin/run
