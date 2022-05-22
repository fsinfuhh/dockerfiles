FROM registry.mafiasi.de/base-bullseye

ARG VERSION=6.7.0

RUN apt update; \
    usermod -u 2003 -g nogroup www-data; \
    apt-get -y --no-install-recommends install wget; \
    wget -nv https://releases.mattermost.com/$VERSION/mattermost-$VERSION-linux-amd64.tar.gz -O- | tar -C /opt -xz; \
    sed -i 's/"login.gitlab":"GitLab"/"login.gitlab":"Login"/' /opt/mattermost/client/*.js; \
    sed -i 's/DIAGNOSTICS_SEGMENT_KEY:"[a-zA-z0-9]*"/DIAGNOSTICS_SEGMENT_KEY:""/' /opt/mattermost/client/*.js; \
    chown -R www-data:nogroup /opt/mattermost

RUN rmdir /opt/mattermost/logs; \
    ln -sf /opt/log /opt/mattermost/logs

COPY run /usr/local/bin/run
EXPOSE 8065
VOLUME /opt/storage /opt/config /opt/log
USER www-data:nogroup
ENTRYPOINT /usr/local/bin/run
