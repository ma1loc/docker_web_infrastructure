ARG IMAGE_VERSION=trixie

FROM debian:${IMAGE_VERSION}

RUN apt update -y && apt upgrade -y \
	&& apt install -y mariadb-server

# runtime files -> /run/mysqld
# by installing mariadb-server it creates "mysql -> system user", "mysql -> group"
# MariaDB needs this for the socket and PID file.
RUN mkdir -p /run/mysqld && \
	chown -R mysql:mysql /run/mysqld

# COPY ./config/init_mariadb.sh /
COPY ./config/init_mariadb.sh /usr/local/bin/init_mariadb.sh
COPY ./config/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod +x /usr/local/bin/init_mariadb.sh

CMD [ "/usr/local/bin/init_mariadb.sh" ]
