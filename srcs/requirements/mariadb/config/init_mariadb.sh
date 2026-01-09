#!/bin/bash

mariadbd --user=mysql &
PID=$!

until mariadb-admin ping --silent; do
    sleep 1
done

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
