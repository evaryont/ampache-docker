#!/bin/bash

if [[ ! -f /var/www/html/config/ampache.cfg.php ]]; then
    echo "=> Copying default configuration file"
    cp /tmp/ampache.cfg.php.dist /var/www/html/config/ampache.cfg.php
    cp /tmp/ampache.cfg.php.dist /var/www/html/config/ampache.cfg.php.dist
fi

if [[ ! -f /var/www/html/config/registration_agreement.php ]]; then
    echo "=> Copying default registration agreement header"
    cp /tmp/registration_agreement.php.dist /var/www/html/config/registration_agreement.php
    cp /tmp/registration_agreement.php.dist /var/www/html/config/registration_agreement.php.dist
fi

# # Start apache in the background
# service apache2 start

# Start cron in the background
echo "=> (todo) Starting cron daemon"
# cron

# Start a process to watch for changes in the library with inotify
echo "=> (todo) Starting inotify based catalog update"
# (
# while true; do
#     inotifywatch /media
#     php /var/www/bin/catalog_update.inc -a
#     sleep 30
# done
# ) &

echo "=> Launching apache2 in the foreground"
apache2-foreground
