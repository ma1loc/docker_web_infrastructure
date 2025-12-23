#!/bin/bash

# >>> tool to manage WordPress from terminal
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

mv ./wp-cli.phar /usr/local/bin/wp	
chmod +x /usr/local/bin/wp

wp cli update

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

# >>> '-S' <addr>:<port> Run with built-in web server.
#		0.0.0.0 -> listen on all interfaces with 80 → HTTP port
# >>> -t <docroot>     Specify document root <docroot> for built-in web server.
exec php -S 0.0.0.0:80 -t /var/www/html/wordpress
