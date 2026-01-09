FROM debian:bookworm

RUN apt update -y && apt upgrade -y \
	&& apt install -y mariadb-server

RUN mkdir -p /run/mysqld /var/lib/mysql && \
	chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY ./config/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./config/init_mariadb.sh /usr/local/bin/init_mariadb.sh
RUN chmod +x /usr/local/bin/init_mariadb.sh

CMD [ "/usr/local/bin/init_mariadb.sh" ]