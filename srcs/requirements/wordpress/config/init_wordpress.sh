#!/bin/bash

# >>> tool to manage WordPress from terminal
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

mv ./wp-cli.phar /usr/local/bin/wp	
chmod +x /usr/local/bin/wp

# >>> download wp core files like {wp-admin, wp-includes, index.php}
wp core download --allow-root \
	--path=/var/www/html/wordpress

#  >>> CREATE The base configuration for WordPress "wp-config.php"
# 		This is how WordPress connects to MariaDB
wp config create --allow-root \
	--path="/var/www/html/wordpress/" \
	--dbname="$WORDPRESS_DB_NAME" \
	--dbuser="$WORDPRESS_DB_USER" \
	--dbpass="$WORDPRESS_DB_PASSWORD" \
	--dbhost="$WORDPRESS_DB_HOST"

# PHP-FPM ----------> "is a get way" -> FastCGI Process Manager (FPM)
exec php-fpm8.4 -F
