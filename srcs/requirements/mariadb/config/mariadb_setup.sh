#!/bin/bash

mariadbd --user=mysql


# SETUP wordpress database 
mysql -u root -p $MYSQL_ROOT_PASSWORD
mysql -u mysql << EOF

CREATE USER ${WORDPRESS_DB_NAME}@'wordpress' IDENTIFIED BY ${WORDPRESS_PASSWORD};

CREATE DATABASE ${WORDPRESS_DB_NAME};
GRANT ALL PRIVILEGES ON wordpress.* TO ${WORDPRESS_DB_NAME}@'localhost';
FLUSH PRIVILEGES;
EXIT;

EOF