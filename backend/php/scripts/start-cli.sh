#!/usr/bin/env /bin/bash

echo "CONFIGURING PHP..."
cp /opt/config/php/php.ini /etc/php/php.ini
cp /opt/config/php/conf.d/* /etc/php/conf.d/

echo "CONFIGURING CRONTAB..."
cp /opt/config/crontab/* /etc/cron.d/
chmod 644 /etc/cron.d/*
for jobs in /etc/cron.d/*; do
    $(which crontab) $jobs
done;

echo "CHANGING PERMISSIONS..."
chown www-data:www-data /var/log/php/*
chown -R www-data:www-data /var/www

if [ -f "/var/www/composer.json" ]; then
    echo "INSTALLING COMPOSER DEPENDENCIES..."
    $(which composer) install --working-dir=/var/www
fi

echo "STARTING SUPERVISORD..."
exec /usr/bin/supervisord -n -c /etc/supervisord.conf