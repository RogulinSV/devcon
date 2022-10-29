#!/usr/bin/env /bin/bash

echo "CONFIGURING PHP..."
cp /opt/config/php/php.ini /etc/php/php.ini
cp /opt/config/php/php-fpm.conf /usr/etc/php-fpm.conf
cp /opt/config/php/php-fpm.d/* /etc/php/php-fpm.d/
cp /opt/config/php/conf.d/* /etc/php/conf.d/

echo "CONFIGURING MAILHOG..."
cp /opt/config/msmtprc /etc/msmtprc

if [ -f "/var/www/composer.json" ]; then
    echo "INSTALLING COMPOSER DEPENDENCIES..."
    $(which composer) install --working-dir=/var/www
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
wget -O /usr/local/bin/phpchck https://github.com/fabpot/local-php-security-checker/releases/download/v2.0.5/local-php-security-checker_2.0.5_linux_amd64 \
    && chmod +x /usr/local/bin/phpchck

echo "CHANGING PERMISSIONS..."
chown www-data:www-data /var/log/php/*
chown -R www-data:www-data /var/www

echo "STARTING SUPERVISORD..."
exec /usr/bin/supervisord -n -c /etc/supervisord.conf