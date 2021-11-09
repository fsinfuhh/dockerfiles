FROM docker.io/debian:bullseye-slim

COPY sources.list /etc/apt/sources.list
RUN apt update; apt upgrade --yes
RUN apt install --yes --no-install-recommends vim ca-certificates procps
RUN apt-get clean
RUN mkdir -p /opt/config /opt/storage /opt/log

ENTRYPOINT /bin/bash
