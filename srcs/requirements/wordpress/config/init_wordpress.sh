#!/bin/bash

# >>> install wp-cli tool to manage WordPress using terminal command instead of the web interface
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
	--dbname="$WP_DB_NAME" \
	--dbuser="$WP_DB_USER" \
	--dbpass="$WP_DB_PASSWORD" \
	--dbhost="$WP_DB_HOST"

# >>> wait for the database to load
# until wp db check --allow-root --path=/var/www/html/wordpress 2>/dev/null; do
#     sleep 2
# done

# >>> check if the wordpress alrady installed
if ! wp core is-installed --allow-root --path=/var/www/html/wordpress 2>/dev/null; then
	# >>> install wp, create wp database table, create admin-user, set URL
	wp core install --allow-root \
		--path=/var/www/html/wordpress \
		--title="Inception" \
		--url="https://$DOMAIN_NAME" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL"

	# >>> create normal user
	wp user create "$WP_USER" "$WP_USER_EMAIL" --allow-root \
		--path=/var/www/html/wordpress \
		--user_pass="$WP_USER_PASSWORD" \
		--role=author # >>> cannot manage the site or othes
fi
# ------------------------------------------------- #

# PHP-FPM ----------> "is a get way" -> FastCGI Process Manager (FPM)
exec php-fpm8.4 -F -R
