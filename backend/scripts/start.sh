#!/usr/bin/env bash

if [ -f "/var/www/composer.json" ]; then
    echo "INSTALLING COMPOSER DEPENDENCIES..."
    $(which composer) install --working-dir=/var/www
fi

if [ -f "/var/www/package.json" ]; then
    echo "INSTALLING NODEJS DEPENDENCIES..."
    $(which npm) install --prefix=/var/www
fi

echo "INSTALLING PHP PACKAGES..."
$(which composer) global require \
    phpstan/phpstan \
    vimeo/psalm \
    phpmetrics/phpmetrics \
    squizlabs/php_codesniffer

echo "DOWNLOADING PHP PACKAGES..."
wget -O /usr/local/bin/phploc https://phar.phpunit.de/phploc.phar \
    && chmod +x /usr/local/bin/phploc
wget -O /usr/local/bin/phpchck https://github.com/fabpot/local-php-security-checker/releases/download/v1.0.0/local-php-security-checker_1.0.0_linux_amd64 \
    && chmod +x /usr/local/bin/phpchck

echo "INSTALLING NODEJS PACKAGES..."
$(which npm) install --global \
    yarn \
    svgo \
    nodemon \
    typescript \
    @types/node

echo "CHANGING PERMISSIONS..."
touch /var/log/node/tsc.log
chown www-data:www-data /var/log/node/tsc.log
chown www-data:www-data /var/log/php/*
chown -R www-data:www-data /var/www

echo "STARTING SUPERVISORD..."
exec /usr/bin/supervisord -n -c /etc/supervisord.conf