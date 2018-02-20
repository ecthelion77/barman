#!/usr/bin/env bash
set -e

chown -R postgres:postgres /var/backups

echo '>>> SETUP BARMAN CRON'
echo "0 0 * * * root barman backup all > /proc/1/fd/1 2> /proc/1/fd/2" >> /etc/cron.d/barman
chmod 0644 /etc/cron.d/barman

echo '>>> STARTING METRICS SERVER'
/go/main &

echo '>>> STARTING CRON'
env >> /etc/environment
cron -f
