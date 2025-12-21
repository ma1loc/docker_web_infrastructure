#!/bin/bash

set -e


mysql_install_db --user=mysql --datadir=/var/lib/mysql

mariadbd --user=mysql --datadir=/var/lib/mysql &

MARIADB_PID=$!

sleep 5

# >>> SETUP wordpress database
# CREATE DATABASE IF NOT EXISTS ${WORDPRESS_DB_NAME};

mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${WORDPRESS_DB_NAME};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${WORDPRESS_DB_NAME}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF


kill $MARIADB_PID # >>> kill is not waiting intel the preccess killed 
wait $MARIADB_PID # >>> that why wait for

exec mariadbd --user=mysql --datadir=/var/lib/mysql		# main process


# JUST comment
<<END
	HERE WILL EXPLINE # SETUP wordpress database
	
	#1 -> CREATE DATABASE IF NOT EXISTS ${WORDPRESS_DB_NAME};
		is create a database in this path /var/lib/mysql/wordpress_db/
		table files, indexes, metadata
	
	#2 -> CREATE USER IF NOT EXISTS '${WORDPRESS_USER}'@'%' IDENTIFIED BY '${WORDPRESS_PASS}';
		is create user, This user is the account WordPress uses to connect to MariaDB.
		why '%' -> '${WORDPRESS_USER}'@'%' ?
		wordpress_container is most communicate with mariadb_container
		WordPress container
    		↓ (Docker bridge network)
		MariaDB container

	#3 -> GRANT ALL PRIVILEGES ON ${WORDPRESS_DB_NAME}.* TO '${WORDPRESS_USER}'@'%';
		it telles ${WORDPRESS_USER} inherat all the privileges mena's it can done
			SELECT, INSERT, UPDATE, DELETE, CREATE TABLE, DROP TABLE, etc…
		but only on ${WORDPRESS_DB_NAME}.*
		* after . = all objects in this database
	
	#4 -> FLUSH PRIVILEGES;
		MariaDB caches privilege tables in memory doesn’t reread them after every change
		reload mysql.user

	TO TEST THE MYSQL DATABASE:
	mysql -u root
		SHOW DATABASES;
END

#	DATABASE COMMANDS TO KNOW
	# SHOW DATABASES
	# CREATE DATABASE 'db-name'
	# DROP DATABASE 'db-name to delete'
	# USE 'db-name' select new db
	# SHOW TABLES -> show info table