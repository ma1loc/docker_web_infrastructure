FROM debian:trixie

RUN apt update -y && apt upgrade -y \
	&& apt install -y mariadb-server

# Ensure directories exist and have correct permissions
RUN mkdir -p /run/mysqld /var/lib/mysql && \
	chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
	chmod 777 /run/mysqld

COPY ./config/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf	
COPY ./config/init_mariadb.sh /usr/local/bin/init_mariadb.sh
RUN chmod +x /usr/local/bin/init_mariadb.sh

# Use the mysql user by default
USER mysql

CMD [ "/usr/local/bin/init_mariadb.sh" ]