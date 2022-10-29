#!/usr/bin/env /bin/bash

if [ -f "/var/www/package.json" ]; then
    echo "INSTALLING NODEJS DEPENDENCIES..."
    $(which npm) install --prefix=/var/www
fi

echo "INSTALLING NODEJS PACKAGES..."
$(which npm) install --global \
    svgo \
    nodemon \
    typescript \
    @types/node

if [ ! -f "/var/www/tsconfig.json" ]; then
    echo "INITIALIZING TYPESCIPT..."
    $(which tsc) --init
fi

echo "CHANGING PERMISSIONS..."
touch /var/log/node/tsc.log
chown www-data:www-data /var/log/node/tsc.log
chown -R www-data:www-data /var/www

echo "STARTING SUPERVISORD..."
exec /usr/bin/supervisord -n -c /etc/supervisord.conf