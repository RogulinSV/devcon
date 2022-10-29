FROM debian:buster-slim

LABEL org.opencontainers.image.authors="sv.rogulin@gmail.com"

ARG NGINX_VERSION=1.22.0
ARG NGINX_MODULE_NGX_VERSION=0.3.1
ARG NGINX_MODULE_LUA_VERSION=0.10.21
ARG NGINX_MODULE_NJS_VERSION=0.7.7
ARG NGINX_MODULE_GEO_VERSION=3.4
ARG NGINX_MODULE_RTMP_VERSION=1.2.2
ARG LUA_VERSION=5.1
ARG LUAJIT_MAJOR_VERSION=2
ARG LUAJIT_MINOR_VERSION=1
ARG LUAJIT_RELEASE_VERSION=20220915
ARG OPENRESTY_VERSION=1.21.4.1
ARG OPENRESTY_MODULE_HEADERS_VERSION=0.33
ARG OPENRESTY_MODULE_ICONV_VERSION=0.14
ARG OPENRESTY_MODULE_POSTGRES_VERSION=1.0
ARG OPENRESTY_MODULE_REDIS2_VERSION=0.15
ARG OPENRESTY_MODULE_SETMISC_VERSION=0.33

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
        supervisor \
# COMPILERS...
        g++ \
        gcc \
        make \
# NGINX DEPENDENCIES...
        libpcre3-dev \
        zlib1g-dev \
        libgd-dev \
        libxslt-dev \
        libssl-dev \
        libperl-dev \
        libmaxminddb-dev \
        libgeoip-dev \
        libpq-dev; \
# CONFIGURING TIMEZONE AND LOCALE...
    echo "CONFIGURING TIMEZONE AND LOCALE..."; \
    locale-gen ru_RU.UTF-8 en_US.UTF-8; \
    touch /etc/tzdata-selection.txt; \
    echo 'tzdata tzdata/Areas select Europe' >> /etc/tzdata-selection.txt; \
    echo 'tzdata tzdata/Zones/Europe select Moscow' >> /etc/tzdata-selection.txt; \
    debconf-set-selections /etc/tzdata-selection.txt; \
    DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true dpkg-reconfigure tzdata; \
# DOWNLOADING SOURCES...
    echo "DOWNLOADING SOURCES..."; \
    wget -O /tmp/nginx-${NGINX_VERSION}.tar.gz https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz; \
    wget -O /tmp/nginx-module-ngx-${NGINX_MODULE_NGX_VERSION}.tar.gz https://github.com/vision5/ngx_devel_kit/archive/v${NGINX_MODULE_NGX_VERSION}.tar.gz; \
    wget -O /tmp/nginx-module-lua-${NGINX_MODULE_LUA_VERSION}.tar.gz https://github.com/openresty/lua-nginx-module/archive/v${NGINX_MODULE_LUA_VERSION}.tar.gz; \
    wget -O /tmp/nginx-module-njs-${NGINX_MODULE_NJS_VERSION}.tar.gz https://github.com/nginx/njs/archive/${NGINX_MODULE_NJS_VERSION}.tar.gz; \
    wget -O /tmp/nginx-module-geo-${NGINX_MODULE_GEO_VERSION}.tar.gz https://github.com/leev/ngx_http_geoip2_module/archive/${NGINX_MODULE_GEO_VERSION}.tar.gz; \
    wget -O /tmp/nginx-module-rtmp-${NGINX_MODULE_RTMP_VERSION}.tar.gz https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_MODULE_RTMP_VERSION}.tar.gz; \
    wget -O /tmp/luajit-${LUAJIT_MAJOR_VERSION}.${LUAJIT_MINOR_VERSION}-${LUAJIT_RELEASE_VERSION}.tar.gz https://github.com/openresty/luajit2/archive/v${LUAJIT_MAJOR_VERSION}.${LUAJIT_MINOR_VERSION}-${LUAJIT_RELEASE_VERSION}.tar.gz; \
    wget -O /tmp/openresty-${OPENRESTY_VERSION}.tar.gz https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz; \
# UNPACKING SOURCES...
    echo "UNPACKING SOURCES..."; \
    tar -zxf /tmp/nginx-${NGINX_VERSION}.tar.gz -C /tmp; \
    tar -zxf /tmp/nginx-module-ngx-${NGINX_MODULE_NGX_VERSION}.tar.gz -C /tmp; \
    tar -zxf /tmp/nginx-module-lua-${NGINX_MODULE_LUA_VERSION}.tar.gz -C /tmp; \
    tar -zxf /tmp/nginx-module-njs-${NGINX_MODULE_NJS_VERSION}.tar.gz -C /tmp; \
    tar -zxf /tmp/nginx-module-geo-${NGINX_MODULE_GEO_VERSION}.tar.gz -C /tmp; \
    tar -zxf /tmp/nginx-module-rtmp-${NGINX_MODULE_RTMP_VERSION}.tar.gz -C /tmp; \
    tar -zxf /tmp/luajit-${LUAJIT_MAJOR_VERSION}.${LUAJIT_MINOR_VERSION}-${LUAJIT_RELEASE_VERSION}.tar.gz -C /tmp; \
    tar -zxf /tmp/openresty-${OPENRESTY_VERSION}.tar.gz -C /tmp; \
# COMPILING LUAJIT...
    echo "COMPILING LUAJIT..."; \
    cd /tmp/luajit${LUAJIT_MAJOR_VERSION}-${LUAJIT_MAJOR_VERSION}.${LUAJIT_MINOR_VERSION}-${LUAJIT_RELEASE_VERSION}; \
    make -j$(nproc); \
    make install; \
    make clean; \
# COMPILING NGINX...
    echo "COMPILING NGINX..."; \
    addgroup --system --gid 199 nginx; \
    adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 199 nginx; \
    cd /tmp/nginx-${NGINX_VERSION}; \
    LUAJIT_LIB=/usr/local/lib LUAJIT_INC=/usr/local/include/luajit-${LUAJIT_MAJOR_VERSION}.${LUAJIT_MINOR_VERSION} ./configure \
        --with-ld-opt="-Wl,-rpath,/usr/local/lib" \
        --with-cc-opt="-Wimplicit-fallthrough=0" \
        --user=nginx \
        --group=nginx \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --with-compat \
        --with-file-aio \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_geoip_module=dynamic \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_image_filter_module=dynamic \
        --with-http_mp4_module \
        --with-http_perl_module=dynamic \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-http_xslt_module=dynamic \
        --with-mail=dynamic \
        --with-mail_ssl_module \
        --with-pcre-jit \
        --with-stream \
        --with-stream_geoip_module=dynamic \
        --with-stream_realip_module \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-threads \
        --without-http_empty_gif_module \
        --with-http_ssl_module \
        --add-module=/tmp/lua-nginx-module-${NGINX_MODULE_LUA_VERSION} \
        --add-module=/tmp/ngx_devel_kit-${NGINX_MODULE_NGX_VERSION} \
        --add-module=/tmp/ngx_http_geoip2_module-${NGINX_MODULE_GEO_VERSION} \
        --add-module=/tmp/njs-${NGINX_MODULE_NJS_VERSION}/nginx \
        --add-dynamic-module=/tmp/nginx-rtmp-module-${NGINX_MODULE_RTMP_VERSION} \
        --add-dynamic-module=/tmp/openresty-${OPENRESTY_VERSION}/bundle/headers-more-nginx-module-${OPENRESTY_MODULE_HEADERS_VERSION} \
        --add-dynamic-module=/tmp/openresty-${OPENRESTY_VERSION}/bundle/iconv-nginx-module-${OPENRESTY_MODULE_ICONV_VERSION} \
        --add-dynamic-module=/tmp/openresty-${OPENRESTY_VERSION}/bundle/ngx_postgres-${OPENRESTY_MODULE_POSTGRES_VERSION} \
        --add-dynamic-module=/tmp/openresty-${OPENRESTY_VERSION}/bundle/redis2-nginx-module-${OPENRESTY_MODULE_REDIS2_VERSION} \
        --add-dynamic-module=/tmp/openresty-${OPENRESTY_VERSION}/bundle/set-misc-nginx-module-${OPENRESTY_MODULE_SETMISC_VERSION}; \
    make -j$(nproc); \
    make install; \
# CONFIGURING NGINX...
    echo "CONFIGURING NGINX..."; \
    rm -rf /etc/nginx/html; \
    mkdir /etc/nginx/conf.d; \
    mkdir /etc/nginx/sites-available; \
    mkdir /etc/nginx/sites-enabled; \
    mkdir /etc/nginx/ssl; \
    mkdir -p /usr/share/nginx/html; \
    mkdir /var/cache/nginx; \
    chown nginx:nginx /var/cache/nginx; \
    install -m644 /tmp/nginx-${NGINX_VERSION}/html/index.html /usr/share/nginx/html/; \
    install -m644 /tmp/nginx-${NGINX_VERSION}/html/50x.html /usr/share/nginx/html/; \
    install -m755 /tmp/nginx-${NGINX_VERSION}/objs/nginx /usr/sbin/nginx; \
    ln -s /usr/lib/nginx/modules /etc/nginx/modules; \
    ls /usr/lib/nginx/modules | grep -v debug | xargs -I {} echo 'load_module "modules/{}";' >> /etc/nginx/modules.conf; \
    mkdir -p /usr/local/share/lua/${LUA_VERSION}/resty; \
    cp -R /tmp/openresty-${OPENRESTY_VERSION}/bundle/lua-resty-*/lib/resty/* /usr/local/share/lua/${LUA_VERSION}/resty/; \
    mkdir -p /var/log/nginx; \
    chown nginx:nginx /var/log/nginx; \
# SMOKE TEST
    echo "CHECKING NGINX..."; \
    nginx -v; \
# CLEANUP
    echo "REMOVING PACKAGES..."; \
    apt-get remove --purge -y \
        wget \
        g++ \
        gcc \
        make; \
    rm -rf /tmp/*;

COPY config/supervisord/supervisord.conf /etc/supervisord.conf
COPY scripts/start.sh /start.sh
COPY scripts/prefix.sh /prefix.sh

# CONFIGURING STARTUP SCRIPTS...
RUN set -eux; \
    echo "CONFIGURING STARTUP SCRIPTS..."; \
    chmod 755 /start.sh; \
    chmod 755 /prefix.sh;

EXPOSE 80 443 9010
VOLUME /var/www
VOLUME /var/log/nginx

WORKDIR "/var/www"
CMD ["/start.sh"]