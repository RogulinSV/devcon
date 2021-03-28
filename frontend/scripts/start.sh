#!/usr/bin/env bash

echo "STARTING SUPERVISORD..."
exec /usr/bin/supervisord -n -c /etc/supervisord.conf