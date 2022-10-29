#!/usr/bin/env /bin/bash

echo "CONFIGURING NGINX..."
cp /opt/config/nginx/nginx.conf /etc/nginx/nginx.conf
cp /opt/config/nginx/sites-available/*.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/*.conf /etc/nginx/sites-enabled/

echo "STARTING SUPERVISORD..."
exec /usr/bin/supervisord -n -c /etc/supervisord.conf