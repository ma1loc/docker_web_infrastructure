#!/bin/bash

# - start mariadb daemon as mysql user
mariadbd --user=mysql &
PID=$!

# - wating intel the daemon it up, before the config
until mariadb-admin ping --silent; do
    sleep 1
done

#line 1 - create an empty Database if not exist called 'wordpress_db' for ex.
#       created, to add it's tables, all that done my wordpress.
#       ${user}@'%' -> any address has log-in & pass: will get access to the mysql database

#line 3 - grant all privilaeges on wordpress_db, '*' = all the tables, to 'bob' user that owned by mariadb, at the same-
#       time user credantions can be used out-mariadb container, over the network like what wordpress deose.

#line 4 - ALTER modifies something that already exists, by defual mariaDB has an internal root use
#       with no passwrod, to access it locally

#line 5 - flash - It tells MariaDB to reload the grant tables from disk into memory without restarting

if [ ! -d "/var/lib/mysql/${WP_DB_NAME}" ]; then
    mariadb <<EOF
CREATE DATABASE IF NOT EXISTS ${WP_DB_NAME};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
fi

mariadb-admin shutdown
wait $PID

exec mariadbd --user=mysql
