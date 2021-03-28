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
wget -O /usr/local/bin/phpchck https://get.sensiolabs.org/security-checker.phar \
    && chmod +x /usr/local/bin/phpchck

echo "UPGRADING NODEJS PACKAGES..."
$(which npm) upgrade --global \
    npm

echo "INSTALLING NODEJS PACKAGES..."
$(which npm) install --global \
    yarn \
    svgo \
    typescript \
    @types/node

echo "STARTING SUPERVISORD..."
exec /usr/bin/supervisord -n -c /etc/supervisord.conf