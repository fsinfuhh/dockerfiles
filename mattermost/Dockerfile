FROM registry.mafiasi.de/base-stretch

ARG VERSION

RUN apt update
RUN usermod -u 2003 -g nogroup www-data
RUN apt-get -y --no-install-recommends install wget
RUN wget -nv https://releases.mattermost.com/$VERSION/mattermost-$VERSION-linux-amd64.tar.gz -O- | tar -C /opt -xz
RUN sed -i 's/"login.gitlab":"GitLab"/"login.gitlab":"Login"/' /opt/mattermost/client/*.js
RUN sed -i 's/DIAGNOSTICS_SEGMENT_KEY:"[a-zA-z0-9]*"/DIAGNOSTICS_SEGMENT_KEY:""/' /opt/mattermost/client/*.js
RUN chown -R www-data:nogroup /opt/mattermost

RUN ln -sf /opt/config/config.json /opt/mattermost/config/config.json
RUN rmdir /opt/mattermost/logs
RUN ln -sf /opt/log /opt/mattermost/logs

COPY run /usr/local/bin/run
EXPOSE 8065
VOLUME /opt/storage /opt/config /opt/log
USER www-data:nogroup
ENTRYPOINT /usr/local/bin/run
