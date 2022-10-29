FROM debian:buster-slim

LABEL org.opencontainers.image.authors="sv.rogulin@gmail.com"

ARG PHP_VERSION=8.1.11
ARG PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
ARG PHP_CPPFLAGS=$PHP_CFLAGS
ARG PHP_LDFLAGS="-Wl,-O1 -pie"
ARG PHP_EXTENSION_APCU_VERSION=5.1.22
ARG PHP_EXTENSION_IGBINARY_VERSION=3.2.9
ARG PHP_EXTENSION_XDEBUG_VERSION=3.1.5
ARG PHP_EXTENSION_XDEBUG_PORT=9003
ARG PHP_EXTENSION_XDEBUG_LOG_LEVEL=7
ARG PHP_EXTENSION_XHPROF_VERSION=2.3.7
ARG PHP_EXTENSION_MEMCACHED_VERSION=3.2.0
ARG PHP_EXTENSION_REDIS_VERSION=5.3.7
ARG PHP_EXTENSION_MONGODB_VERSION=1.14.1
ARG PHP_EXTENSION_GRPC_VERSION=1.49.0
ARG PHP_EXTENSION_PROTOBUF_VERSION=3.21.7
ARG PHP_EXTENSION_YAML_VERSION=2.2.2
ARG PHP_EXTENSION_SWOOLE_VERSION=4.8.12
ARG PHP_EXTENSION_MAILPARSE_VERSION=3.1.4
ARG PHP_EXTENSION_IMAGICK_BRANCH=3.7.0
ARG PHP_EXTENSION_AMQP_BRANCH=v1.11.0
ARG ORACLE_CLIENT_MAJOR_VERSION=21
ARG ORACLE_CLIENT_MINOR_VERSION=7
ARG ORACLE_CLIENT_BRANCH=217000
ARG ORACLE_CLIENT_VERSION="x64-21.7.0.0.0dbru"
ARG ORACLE_NLS_LANG=American_America.CL8MSWIN1251
ARG MOZJPEG_VERSION=4.1.1
ARG GIFSICLE_VERSION=1.93
ARG MAILHOG_VERSION=1.0.1
ARG MAILHOG_STORAGE="maildir"
# ARG MAILHOG_STORAGE="memory"

ENV PATH /usr/lib/oracle/instantclient_${ORACLE_CLIENT_MAJOR_VERSION}_${ORACLE_CLIENT_MINOR_VERSION}:${PATH}
ENV ORACLE_HOME /usr/lib/oracle/instantclient_${ORACLE_CLIENT_MAJOR_VERSION}_${ORACLE_CLIENT_MINOR_VERSION}
ENV LD_LIBRARY_PATH /usr/lib/oracle/instantclient_${ORACLE_CLIENT_MAJOR_VERSION}_${ORACLE_CLIENT_MINOR_VERSION}
ENV TNS_ADMIN /usr/lib/oracle/instantclient_${ORACLE_CLIENT_MAJOR_VERSION}_${ORACLE_CLIENT_MINOR_VERSION}/
ENV NLS_LANG ${ORACLE_NLS_LANG}
ENV MH_HOSTNAME ${HOSTNAME}
ENV MH_SMTP_BIND_ADDR 0.0.0.0:1025
ENV MH_API_BIND_ADDR 0.0.0.0:8025
ENV MH_UI_BIND_ADDR 0.0.0.0:8025
ENV MH_STORAGE ${MAILHOG_STORAGE}
ENV MH_MAILDIR_PATH /var/mailhog
ENV http_proxy=${SECURITY_HTTP_PROXY:-}
ENV https_proxy=${SECURITY_HTTPS_PROXY:-}

# INSTALLING PACKAGES...
RUN set -eux; \
    echo "INSTALLING PACKAGES..."; \
    { echo 'Package: php*'; echo 'Pin: release *'; echo 'Pin-Priority: -1'; } > /etc/apt/preferences.d/no-debian-php; \
    apt-get update; \
    apt-get install --no-install-recommends --no-install-suggests -y \
# UTILS...
        locales \
        tzdata \
        wget \
        ca-certificates \
        unzip \
        supervisor \
        msmtp-mta \
        wkhtmltopdf \
        ffmpeg \
        jpegoptim \
        optipng \
        git \
# COMPILERS...
        g++ \
        gcc \
        make \
        cmake \
        pkg-config \
        autoconf \
        dpkg-dev \
        file \
        nasm \
# PHP DEPENDENCIES...
        ghostscript \
        libaio1 \
        libzip-dev \
        libargon2-dev \
        libcurl4-openssl-dev \
        libedit-dev \
        libc-client-dev \
        libldb-dev \
        libldap2-dev \
        libsodium-dev \
        libsqlite3-dev \
        libxml2-dev \
        libkrb5-dev \
        libbz2-dev \
        libffi-dev \
        libgmp-dev \
        libwebp-dev \
        libpng-dev \
        libonig-dev \
        libreadline-dev \
        libtidy-dev \
        libmagickwand-dev \
        libmemcached-dev \
        libgs-dev \
        libyaml-dev \
        librabbitmq-dev \
        libxslt-dev \
        libpq-dev; \
# CONFIGURING TIMEZONE AND LOCALE...
    echo "CONFIGURING TIMEZONE AND LOCALE..."; \
    locale-gen ru_RU.UTF-8 en_US.UTF-8; \
    touch /etc/tzdata-selection.txt; \
    echo 'tzdata tzdata/Areas select Europe' >> /etc/tzdata-selection.txt; \
    echo 'tzdata tzdata/Zones/Europe select Moscow' >> /etc/tzdata-selection.txt; \
    debconf-set-selections /etc/tzdata-selection.txt; \
    DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure tzdata; \
# CONFIGURING MSMTP...
    echo "CONFIGURING MSMTP..."; \
    touch /var/log/msmtp.log; \
    chown www-data:www-data /var/log/msmtp.log;

## PACKAGES: MOZJPEG, GIFSICLE
# DOWNLOADING SOURCES...
RUN set -eux; \
    echo "DOWNLOADING SOURCES..."; \
    wget -O /tmp/mozjpeg-${MOZJPEG_VERSION}.tar.gz https://github.com/mozilla/mozjpeg/archive/v${MOZJPEG_VERSION}.tar.gz; \
    wget -O /tmp/gifsicle-${GIFSICLE_VERSION}.tar.gz https://github.com/kohler/gifsicle/archive/v${GIFSICLE_VERSION}.tar.gz; \
# UNPACKING SOURCES...
    echo "UNPACKING SOURCES..."; \
    tar -zxf /tmp/mozjpeg-${MOZJPEG_VERSION}.tar.gz -C /tmp; \
    tar -zxf /tmp/gifsicle-${GIFSICLE_VERSION}.tar.gz -C /tmp; \
# COMPILING MOJZPEG...
    echo "COMPILING MOJZPEG..."; \
    cd /tmp/mozjpeg-${MOZJPEG_VERSION}; \
    mkdir build; \
    cd build; \
    cmake -G"Unix Makefiles" ../; \
    make; \
    make install; \
    ln -s /opt/mozjpeg/bin/jpegtran /usr/bin/mozjpeg; \
# SMOKE TEST
    echo "CHECKING MOJZPEG..."; \
    mozjpeg -version; \
# COMPILING GIFSICLE...
    echo "COMPILING GIFSICLE..."; \
    cd /tmp/gifsicle-${GIFSICLE_VERSION}; \
    autoreconf -i; \
    ./configure \
        --prefix=/usr/local \
        --disable-gifview \
        --disable-warnings; \
    make; \
    make install; \
# SMOKE TEST
    echo "CHECKING GIFSICLE..."; \
    gifsicle --version; \
# CLEANUP
    echo "REMOVING PACKAGES..."; \
    rm -rf /tmp/*;

## PACKAGES: MAILHOG
# DOWNLOADING SOURCES...
RUN set -eux; \
    echo "DOWNLOADING SOURCES..."; \
    wget -O /tmp/mailhog https://github.com/mailhog/MailHog/releases/download/v${MAILHOG_VERSION}/MailHog_linux_amd64; \
# INSTALLIGN MAILHOG...
    echo "INSTALLING MAILHOG..."; \
    addgroup --system --gid 1001 mailhog; \
    adduser --system --disabled-login --ingroup mailhog --no-create-home --home /nonexistent --gecos "mailhog user" --shell /bin/false --uid 1001 mailhog; \
    mkdir ${MH_MAILDIR_PATH}; \
    chown mailhog:mailhog ${MH_MAILDIR_PATH}; \
    mv /tmp/mailhog /usr/local/bin/mailhog; \
    chmod +x /usr/local/bin/mailhog;

## PACKAGE: PHP
# DOWNLOADING SOURCES...
RUN set -eux; \
    echo "DOWNLOADING SOURCES..."; \
    wget -O /tmp/php-${PHP_VERSION}.tar.gz https://www.php.net/distributions/php-${PHP_VERSION}.tar.gz; \
    wget -O /tmp/instantclient-basic-linux.${ORACLE_CLIENT_VERSION}.zip https://download.oracle.com/otn_software/linux/instantclient/${ORACLE_CLIENT_BRANCH}/instantclient-basic-linux.${ORACLE_CLIENT_VERSION}.zip; \
    wget -O /tmp/instantclient-sqlplus-linux.${ORACLE_CLIENT_VERSION}.zip https://download.oracle.com/otn_software/linux/instantclient/${ORACLE_CLIENT_BRANCH}/instantclient-sqlplus-linux.${ORACLE_CLIENT_VERSION}.zip; \
    wget -O /tmp/instantclient-sdk-linux.${ORACLE_CLIENT_VERSION}.zip https://download.oracle.com/otn_software/linux/instantclient/${ORACLE_CLIENT_BRANCH}/instantclient-sdk-linux.${ORACLE_CLIENT_VERSION}.zip; \
    wget -O /tmp/instantclient-jdbc-linux.${ORACLE_CLIENT_VERSION}.zip https://download.oracle.com/otn_software/linux/instantclient/${ORACLE_CLIENT_BRANCH}/instantclient-jdbc-linux.${ORACLE_CLIENT_VERSION}.zip; \
    wget -O /tmp/instantclient-odbc-linux.${ORACLE_CLIENT_VERSION}.zip https://download.oracle.com/otn_software/linux/instantclient/${ORACLE_CLIENT_BRANCH}/instantclient-odbc-linux.${ORACLE_CLIENT_VERSION}.zip; \
    wget -O /tmp/composer-installer.php https://getcomposer.org/installer; \
    git clone --branch ${PHP_EXTENSION_IMAGICK_BRANCH} --depth 1 https://github.com/Imagick/imagick /tmp/imagick; \
    git clone --branch ${PHP_EXTENSION_AMQP_BRANCH} --depth 1 https://github.com/php-amqp/php-amqp.git /tmp/amqp; \
# UNPACKING SOURCES...
    echo "UNPACKING SOURCES..."; \
    tar -zxf /tmp/php-${PHP_VERSION}.tar.gz -C /tmp; \
    mkdir -p /usr/lib/oracle; \
    unzip /tmp/instantclient-basic-linux.${ORACLE_CLIENT_VERSION}.zip -d /usr/lib/oracle; \
    unzip /tmp/instantclient-sqlplus-linux.${ORACLE_CLIENT_VERSION}.zip -d /usr/lib/oracle; \
    unzip /tmp/instantclient-sdk-linux.${ORACLE_CLIENT_VERSION}.zip -d /usr/lib/oracle; \
    unzip /tmp/instantclient-jdbc-linux.${ORACLE_CLIENT_VERSION}.zip -d /usr/lib/oracle; \
    unzip /tmp/instantclient-odbc-linux.${ORACLE_CLIENT_VERSION}.zip -d /usr/lib/oracle; \
# COMPILING PHP...
    echo "COMPILING PHP..."; \
    ln -s /usr/lib/libc-client.a /usr/lib/x86_64-linux-gnu/libc-client.a; \
    ln -s /usr/lib/libc-client.so /usr/lib/x86_64-linux-gnu/libc-client.so; \
    cd /tmp/php-${PHP_VERSION}; \
    CFLAGS="${PHP_CFLAGS}" CPPFLAGS="${PHP_CPPFLAGS}" LDFLAGS="${PHP_LDFLAGS}" ./configure \
        --prefix=/usr \
        --enable-option-checking=fatal \
        --with-config-file-path=/etc/php \
        --with-config-file-scan-dir=/etc/php/conf.d \
        --with-fpm-group=www-data \
        --with-fpm-user=www-data \
        --enable-fpm \
        --disable-cgi \
        --disable-rpath \
        --disable-phpdbg \
        --enable-bcmath \
        --enable-calendar \
        --enable-exif \
        --enable-gd \
        --enable-intl \
        --enable-mbregex \
        --enable-mbstring \
        --enable-opcache \
        --enable-pcntl \
        --enable-shmop \
        --enable-soap \
        --enable-sockets \
        --enable-sysvsem \
        --enable-sysvshm \
        --with-bz2 \
        --with-curl \
        --with-ffi \
        --with-freetype \
        --with-gettext \
        --with-gmp \
        --with-imap \
        --with-imap-ssl \
        --with-jpeg \
        --with-kerberos \
        --with-ldap \
        --with-libdir=lib/x86_64-linux-gnu \
        --with-mhash \
        --with-pic \
        --with-mysql-sock=/var/run/mysqld/mysqld.sock \
        --with-mysqli \
        --with-openssl \
        --with-password-argon2 \
        --with-pcre-jit \
        --with-pdo-pgsql=/usr \
        --with-pdo-mysql=mysqlnd \
        --with-pdo-sqlite=/usr \
        --with-pear \
        --with-pgsql \
        --with-readline \
        --with-sodium=shared \
        --with-sqlite3=/usr \
        --with-tidy \
        --with-webp \
        --with-xsl \
        --with-zip \
        --with-zlib \
        --with-zlib-dir; \
    make -j$(nproc); \
    find -type f -name '*.a' -delete; \
    make install; \
    find /usr/local -type f -perm '/0111' -exec sh -euxc 'strip --strip-all "$@" || :' -- '{}' + ; \
# COMPILING PHP EXTENSIONS...
    echo "COMPILING PHP EXTENSIONS..."; \
    mkdir -p /etc/php/conf.d/; \
    cd /tmp/php-${PHP_VERSION}/ext/oci8; \
    /usr/bin/phpize; \
    ./configure \
        --prefix=/usr \
        --with-oci8=instantclient,/usr/lib/oracle/instantclient_${ORACLE_CLIENT_MAJOR_VERSION}_${ORACLE_CLIENT_MINOR_VERSION},${ORACLE_CLIENT_MAJOR_VERSION}.${ORACLE_CLIENT_MINOR_VERSION}; \
    make -j$(nproc); \
    make install; \
    echo 'extension=oci8' > /etc/php/conf.d/php-ext-oci8.ini; \
    cd /tmp/php-${PHP_VERSION}/ext/pdo_oci; \
    /usr/bin/phpize; \
    ./configure \
        --prefix=/usr \
        --with-pdo-oci=instantclient,/usr/lib/oracle/instantclient_${ORACLE_CLIENT_MAJOR_VERSION}_${ORACLE_CLIENT_MINOR_VERSION},${ORACLE_CLIENT_MAJOR_VERSION}.${ORACLE_CLIENT_MINOR_VERSION}; \
    make -j$(nproc); \
    make install; \
    echo 'extension=pdo_oci' > /etc/php/conf.d/php-ext-pdo-oci.ini; \
    pecl channel-update pecl.php.net; \
    pecl install apcu-${PHP_EXTENSION_APCU_VERSION}; \
    echo 'extension=apcu' > /etc/php/conf.d/php-ext-apcu.ini; \
    pecl install igbinary-${PHP_EXTENSION_IGBINARY_VERSION}; \
    echo 'extension=igbinary' > /etc/php/conf.d/php-ext-igbinary.ini; \
    pecl install xdebug-${PHP_EXTENSION_XDEBUG_VERSION}; \
    echo 'zend_extension=xdebug' > /etc/php/conf.d/php-ext-xdebug.ini; \
    pecl install xhprof-${PHP_EXTENSION_XHPROF_VERSION}; \
    echo 'extension=xhprof' > /etc/php/conf.d/php-ext-xhprof.ini; \
    pecl install --nobuild memcached-${PHP_EXTENSION_MEMCACHED_VERSION}; \
    cd "$(pecl config-get temp_dir)/memcached"; \
    /usr/bin/phpize; \
    ./configure \
        --prefix=/usr \
        --enable-memcached-igbinary \
        --enable-memcached-json; \
    make -j$(nproc); \
    make install; \
    echo 'extension=memcached' > /etc/php/conf.d/php-ext-memcached.ini; \
    pecl install --nobuild redis-${PHP_EXTENSION_REDIS_VERSION}; \
    cd "$(pecl config-get temp_dir)/redis"; \
    /usr/bin/phpize; \
    ./configure \
        --prefix=/usr \
        --enable-redis-igbinary; \
    make -j$(nproc); \
    make install; \
    echo 'extension=redis' > /etc/php/conf.d/php-ext-redis.ini; \
    pecl install mongodb-${PHP_EXTENSION_MONGODB_VERSION}; \
    echo 'extension=mongodb' > /etc/php/conf.d/php-ext-mongodb.ini; \
    pecl install mailparse-${PHP_EXTENSION_MAILPARSE_VERSION}; \
    echo 'extension=mailparse' > /etc/php/conf.d/php-ext-mailparse.ini; \
    cd /tmp/imagick; \
    /usr/bin/phpize; \
    ./configure; \
    make -j$(nproc); \
    make install; \
    # pecl install imagick; \
    echo 'extension=imagick' > /etc/php/conf.d/php-ext-imagick.ini; \
    pecl install --nobuild grpc-${PHP_EXTENSION_GRPC_VERSION}; \
    cd "$(pecl config-get temp_dir)/grpc"; \
    /usr/bin/phpize; \
    ./configure \
        --prefix=/usr \
        --enable-grpc; \
    make -j$(nproc); \
    make install; \
    echo 'extension=grpc' > /etc/php/conf.d/php-ext-grpc.ini; \
    pecl install protobuf-${PHP_EXTENSION_PROTOBUF_VERSION}; \
    echo 'extension=protobuf' > /etc/php/conf.d/php-ext-protobuf.ini; \
    echo | pecl install yaml-${PHP_EXTENSION_YAML_VERSION}; \
    echo 'extension=yaml' > /etc/php/conf.d/php-ext-yaml.ini; \
    cd /tmp/amqp; \
    /usr/bin/phpize; \
    ./configure; \
    make -j$(nproc); \
    make install; \
    # pecl install amqp; \
    echo 'extension=amqp' > /etc/php/conf.d/php-ext-amqp.ini; \
    pecl install --nobuild swoole-${PHP_EXTENSION_SWOOLE_VERSION}; \
    cd "$(pecl config-get temp_dir)/swoole"; \
    /usr/bin/phpize; \
    ./configure \
        --prefix=/usr \
        --enable-debug-log \
        --enable-sockets \
        --enable-openssl \
        --enable-http2 \
        --enable-swoole \
        --enable-mysqlnd \
        --enable-swoole-json \
        --enable-swoole-curl; \
    make -j$(nproc); \
    make install; \
    echo 'extension=swoole' > /etc/php/conf.d/php-ext-swoole.ini; \
    echo 'extension=sodium' > /etc/php/conf.d/php-ext-sodium.ini; \
    echo 'zend_extension=opcache' > /etc/php/conf.d/php-ext-opcache.ini; \
# CONFIGURING PHP...
    echo "CONFIGURING PHP..."; \
    ln -s /usr/etc/php-fpm.d /etc/php/php-fpm.d; \
    { \
        echo "env[ORACLE_HOME] = ${ORACLE_HOME}"; \
        echo "env[TNS_ADMIN] = ${ORACLE_HOME}/"; \
        echo "env[NLS_LANG] = ${ORACLE_NLS_LANG}"; \
	} >> /usr/etc/php-fpm.d/php-fpm-env.conf; \
    { \
        echo 'sendmail_path=/usr/bin/msmtp -t'; \
    } > /etc/php/conf.d/php-ext-sendmail.ini; \
    mkdir -p /var/log/php; \
    touch /var/log/php/access.log; \
    chown www-data:www-data /var/log/php/access.log; \
    touch /var/log/php/error.log; \
    chown www-data:www-data /var/log/php/error.log; \
    touch /var/log/php/slow.log; \
    chown www-data:www-data /var/log/php/slow.log; \
    touch /var/log/php/xdebug.log; \
    chown www-data:www-data /var/log/php/xdebug.log; \
    mkdir -p /var/log/php/cachegrind; \
    chown www-data:www-data /var/log/php/cachegrind; \
# SMOKE TEST
    echo "CHECKING PHP..."; \
    php --version; \
# INSTALLING COMPOSER...
    echo "INSTALLING COMPOSER..."; \
    php /tmp/composer-installer.php --install-dir=/usr/local/bin --filename=composer; \
# SMOKE TEST
    echo "CHECKING COMPOSER..."; \
    composer --version; \
# CLEANUP
    echo "REMOVING PACKAGES..."; \
    pecl clear-cache; \
    rm ~/.pearrc; \
    rm -rf /usr/src/php; \
    rm -rf /tmp/*; \
# SYSTEM CLEANUP...
    echo "SYSTEM CLEANUP..."; \
    apt-get remove --purge -y \
        git \
        g++ \
        gcc \
        make \
        pkg-config \
        autoconf \
        dpkg-dev \
        file \
        nasm;
    # find /usr/local -type f -executable -or -name \*.so -exec ldd '{}' ';' | awk '/=>/ { print $(NF-1) }' | sort -u | xargs -r dpkg-query --search | cut -d: -f1 | sort -u | xargs -r apt-mark manual; \
    # apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \

COPY config/supervisord/supervisord.conf /etc/supervisord.conf
COPY scripts/start.sh /start.sh
COPY scripts/prefix.sh /prefix.sh

# CONFIGURING STARTUP SCRIPTS...
RUN set -eux; \
    echo "CONFIGURING STARTUP SCRIPTS..."; \
    chmod 755 /start.sh; \
    chmod 755 /prefix.sh

EXPOSE 8025 9003 9011
VOLUME /var/mailhog
VOLUME /var/www
VOLUME /var/log/php
# VOLUME /var/log/profiler

WORKDIR "/var/www"
CMD ["/start.sh"]