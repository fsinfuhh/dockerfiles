FROM docker.io/kanboard/kanboard

COPY run /usr/local/bin
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/usr/local/bin/run"]

VOLUME /opt/config

