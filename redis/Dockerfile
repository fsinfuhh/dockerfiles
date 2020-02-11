FROM registry.mafiasi.de/base-buster

RUN apt-get -y --no-install-recommends install redis-server; \
    apt-get clean; \
    service redis-server stop; \
    usermod -g nogroup -u 2003 redis; \
    chown -R redis:nogroup /var/log/redis; \
    chown -R redis /etc/redis; \
    sed -i "s/daemonize yes/daemonize no/g" /etc/redis/redis.conf; \
    sed -i "s/# bind 127.0.0.1/bind 127.0.0.1/g" /etc/redis/redis.conf; \
    rm -r /var/lib/redis; \
    ln -sf /opt/storage/redis /var/lib

USER redis:nogroup
VOLUME /opt/storage
EXPOSE 6379
ENTRYPOINT /usr/bin/redis-server
# /etc/redis/redis.conf (for some reason, redis config is not working)
