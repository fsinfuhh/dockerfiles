FROM node:12-buster

ENV VERSION=1.8.14

RUN mkdir -p /app/etherpad; \
    wget -nv https://github.com/ether/etherpad-lite/archive/$VERSION.tar.gz -O- | tar -C /app/etherpad --strip-components=1 -xz

WORKDIR /app/etherpad
# ep_latexexport is currently not installed because it is not compatible with the new etherpad version
RUN bin/installDeps.sh; \
    npm install ep_adminpads2 \
		ep_align \
		ep_authornames \
		ep_ether-o-meter \
		ep_headings2 \
		ep_hide_referrer \
		ep_line_height \
		ep_message_all \
		ep_subscript_and_superscript; \
     ln -sf /app/config/settings.json /app/etherpad/settings.json ; \
     ln -sf /app/config/APIKEY.txt /app/etherpad/APIKEY.txt ;

VOLUME /app/config
EXPOSE 9001/tcp
CMD /app/etherpad/bin/run.sh --root
