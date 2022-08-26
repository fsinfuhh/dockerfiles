FROM registry.mafiasi.de/base-bullseye

ENV VERSION=1.17.1
ENV UID=2001

RUN useradd -u $UID -g nogroup git -d /home/gitea -m

RUN apt update; \
    apt-get --no-install-recommends -y install git openssl openssh-client openssh-server wget xz-utils

RUN mkdir /opt/gitea; \
    chown -R git:nogroup /opt
USER git
WORKDIR /opt/gitea
RUN wget -q https://github.com/go-gitea/gitea/releases/download/v$VERSION/gitea-$VERSION-linux-amd64.xz -O- | xz -d > gitea; \
    chmod +x gitea

RUN mkdir -p /opt/gitea/custom/conf; \
    ln -sf /opt/config/app.ini /opt/gitea/custom/conf/; \
    ln -s /opt/storage/data /opt/gitea/data; \
    chown git /opt/log

USER root
RUN usermod -d /opt/storage/gituser git
RUN echo "AcceptEnv SSH_ORIGINAL_COMMAND" >> /etc/ssh/sshd_config

COPY run /usr/local/bin/run
EXPOSE 3005/tcp 3006/tcp
VOLUME /opt/storage /opt/config
ENTRYPOINT /usr/local/bin/run
