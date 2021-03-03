FROM docker.io/openjdk:11-jdk-slim

# install runtime
ARG TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/sbin/tini
RUN chmod +x /usr/local/sbin/tini
ADD cmd.sh /usr/local/sbin/cmd.sh
ENTRYPOINT ["/usr/local/sbin/tini", "--"]
CMD ["/usr/local/sbin/cmd.sh"]

# install PaperMc (Minecraft Server)
WORKDIR /app/src
ARG MC_VERSION=1.16.5
ARG PAPER_BUILD=509
ADD https://papermc.io/api/v2/projects/paper/versions/${MC_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MC_VERSION}-${PAPER_BUILD}.jar /app/src/paper.jar

# install MultiVerse plugin for multiple world support
ARG PLUGIN_MULTIVERSE_VERSION=4.2.2
ARG PLUGIN_MULTIVERSE_INVENTORIES_VERSION=4.2.1
ADD https://media.forgecdn.net/files/3074/594/Multiverse-Core-${PLUGIN_MULTIVERSE_VERSION}.jar /app/src/plugins/multiverse-core.jar
ADD https://media.forgecdn.net/files/3074/607/Multiverse-Inventories-${PLUGIN_MULTIVERSE_INVENTORIES_VERSION}.jar /app/src/plugins/multiverse-inventories.jar

ADD eula.txt /app/data/eula.txt

EXPOSE 25565/tcp
WORKDIR /app/data
VOLUME /app/data
