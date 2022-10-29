FROM redis:7.0.5

RUN set -eux; \
    echo "CONFIGURING REDIS..."; \
    mkdir -p /var/log/redis/; \
    chown redis:redis /var/log/redis/; \
    touch /var/log/redis/redis.log; \
    chown redis:redis /var/log/redis/redis.log;

COPY config/redis.conf /usr/local/etc/redis/redis.conf

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]