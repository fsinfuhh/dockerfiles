FROM debian:stretch

ENV UID=2001
RUN useradd -u $UID -g nogroup gogs -d /home/gogs -m

RUN apt update
RUN apt-get --no-install-recommends -y install git openssl ca-certificates openssh-client openssh-server wget

RUN chown -R gogs:nogroup /opt
WORKDIR /opt
USER gogs
RUN wget -q https://github.com/gogs/gogs/releases/download/v0.11.19/linux_amd64.tar.gz -O- | tar -xz
WORKDIR /opt/gogs

RUN mkdir -p /opt/gogs/custom/conf
RUN ln -sf /opt/config/app.ini /opt/gogs/custom/conf/
RUN ln -s /opt/storage/data /opt/gogs/data

USER root
RUN usermod -d /opt/storage/gituser gogs
RUN echo "AcceptEnv SSH_ORIGINAL_COMMAND" >> /etc/ssh/sshd_config

COPY run /usr/local/bin/run
EXPOSE 3005/tcp 3006/tcp
VOLUME /opt/storage /opt/config /opt/log
ENTRYPOINT /usr/local/bin/run
