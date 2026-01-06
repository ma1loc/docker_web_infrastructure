#!/bin/bash

# Create directory if it doesn't exist
mkdir -p /var/www/html/wordpress
cd /var/www/html/wordpress

# if ! wp core is-installed --allow-root; then
if [ ! -f "wp-config.php" ]; then

    wp core download --allow-root
    
    wp config create --allow-root \
        --dbname="$WP_DB_NAME" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="mariadb:3306"

    wp core install --allow-root \
        --url="https://$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL"

    wp user create "$WP_USER" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASSWORD" --role=author --allow-root
fi

mkdir -p /run/php

exec php-fpm8.4 -F -R
