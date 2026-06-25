#!/bin/bash

mkdir -p /var/www/html/wordpress
cd /var/www/html/wordpress

if [ ! -f "wp-config.php" ]; then

    # > install all the wp core files wp needed
    wp core download --allow-root
    
    # > config database
    wp config create --allow-root \
        --dbname="$WP_DB_NAME" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="mariadb:3306"

    # > core install: config wp admin credntoins, and 
    wp core install --allow-root \
        --url="https://$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root
fi

# > php-fpm sockets placeholder dir
mkdir -p /run/php

# > -F = foreground process
# > -R = run as root
exec php-fpm8.2 -F -R
