#!/bin/bash

# >>> curling the wp-cli to manage and config the WP fully from the [CLI]
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

mv ./wp-cli.phar /usr/local/bin/wp

chmod +x /usr/local/bin/wp

wp cli update

wp core download --allow-root \
	--path=/var/www/html/wordpress


wp config create --allow-root \
	--path="/var/www/html/wordpress/" \
	--dbname="$WORDPRESS_DB_NAME" \
	--dbuser="$WORDPRESS_DB_USER" \
	--dbpass="$WORDPRESS_DB_PASSWORD" \
	--dbhost="$WORDPRESS_DB_HOST"


# exec php -S 0.0.0.0:3306 -t /var/www/html # why this command look like this ?
exec php -S 0.0.0.0:80 -t /var/www/html/wordpress
