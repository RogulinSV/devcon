#!/usr/bin/env /bin/bash

echo "CONFIGURING PHP..."
cp /opt/config/php/php.ini /etc/php/php.ini
cp /opt/config/php/php-fpm.conf /usr/etc/php-fpm.conf
cp /opt/config/php/php-fpm.d/* /etc/php/php-fpm.d/
cp /opt/config/php/conf.d/* /etc/php/conf.d/

echo "CHANGING PERMISSIONS..."
chown www-data:www-data /var/log/php/*
chown -R www-data:www-data /var/www

if [ -f "/var/www/composer.json" ]; then
    echo "INSTALLING COMPOSER DEPENDENCIES..."
    $(which composer) install --working-dir=/var/www
fi

echo "STARTING SUPERVISORD..."
exec /usr/bin/supervisord -n -c /etc/supervisord.conf