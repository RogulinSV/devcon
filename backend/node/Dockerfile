FROM debian:buster-slim

LABEL org.opencontainers.image.authors="sv.rogulin@gmail.com"

ARG NODE_VERSION=18.11.0
ARG YARN_VERSION=1.22.19

ENV http_proxy=${SECURITY_HTTP_PROXY:-}
ENV https_proxy=${SECURITY_HTTPS_PROXY:-}

# INSTALLING PACKAGES...
RUN set -eux; \
    echo "INSTALLING PACKAGES..."; \
    apt-get update; \
    apt-get install --no-install-recommends --no-install-suggests -y \
# UTILS...
        locales \
        tzdata \
        wget \
        ca-certificates \
        python3 \
        supervisor \
# COMPILERS...
        g++ \
        gcc \
        make; \
# CONFIGURING TIMEZONE AND LOCALE...
    echo "CONFIGURING TIMEZONE AND LOCALE..."; \
    locale-gen ru_RU.UTF-8 en_US.UTF-8; \
    touch /etc/tzdata-selection.txt; \
    echo 'tzdata tzdata/Areas select Europe' >> /etc/tzdata-selection.txt; \
    echo 'tzdata tzdata/Zones/Europe select Moscow' >> /etc/tzdata-selection.txt; \
    debconf-set-selections /etc/tzdata-selection.txt; \
    DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure tzdata;

## PACKAGES: NODEJS, YARN
# DOWNLOADING SOURCES...
RUN set -eux; \
    echo "DOWNLOADING SOURCES..."; \
    wget -O /tmp/node-${NODE_VERSION}.tar.gz https://github.com/nodejs/node/archive/v${NODE_VERSION}.tar.gz; \
    wget -O /tmp/yarn-${YARN_VERSION}.tar.gz https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz; \
# UNPACKING SOURCES...
    echo "UNPACKING SOURCES..."; \
    tar -zxf /tmp/node-${NODE_VERSION}.tar.gz -C /tmp; \
    tar -zxf /tmp/yarn-${YARN_VERSION}.tar.gz -C /tmp; \
# COMPILING NODEJS...
    echo "COMPILING NODEJS..."; \
    addgroup --system --gid 1000 node; \
    adduser --system --disabled-login --ingroup node --no-create-home --home /nonexistent --gecos "node user" --shell /bin/false --uid 1000 node; \
    cd /tmp/node-${NODE_VERSION}; \
    ./configure \
        --prefix=/usr/local \
        --verbose; \
    make -j$(nproc); \
    make install; \
    ln -s /usr/local/bin/node /usr/local/bin/nodejs; \
# CONFIGURING NODEJS...
    echo "CONFIGURING NODEJS..."; \
    mkdir -p /var/log/node; \
    chown www-data:www-data /var/log/node; \
# INSTALLIGN YARN...
    echo "INSTALLING YARN..."; \
    mkdir -p /opt/yarn/bin /opt/yarn/lib; \
    chown www-data:www-data /opt/yarn/bin /opt/yarn/lib; \
    cp /tmp/yarn-v${YARN_VERSION}/bin/* /opt/yarn/bin/; \
    cp /tmp/yarn-v${YARN_VERSION}/lib/* /opt/yarn/lib/; \
    ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn; \
    ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg; \
# SMOKE TEST
    echo "CHECKING NODEJS..."; \
    node --version; \
    npm --version; \
    npx --version; \
    yarn --version; \
# CLEANUP
    echo "REMOVING PACKAGES..."; \
    npm cache clean --force; \
    rm -rf /tmp/*; \
# SYSTEM CLEANUP...
    echo "SYSTEM CLEANUP..."; \
    apt-get remove --purge -y \
        python3 \
        g++ \
        gcc \
        make;

COPY config/supervisord/supervisord.conf /etc/supervisord.conf
COPY scripts/start.sh /start.sh
COPY scripts/prefix.sh /prefix.sh

# CONFIGURING STARTUP SCRIPTS...
RUN set -eux; \
    echo "CONFIGURING STARTUP SCRIPTS..."; \
    chmod 755 /start.sh; \
    chmod 755 /prefix.sh

EXPOSE 3000 5000 9012
VOLUME /var/www
VOLUME /var/log/node

WORKDIR "/var/www"
CMD ["/start.sh"]