FROM debian:bookworm

RUN apt update -y && apt upgrade -y \
	&& apt install -y mariadb-server

# CMD:
# - /run/mysqld => mysql -u root -p<pass> -S /run/mysqld/mysqld.sock
# - /var/lib/mysql => db files
RUN mkdir -p /run/mysqld /var/lib/mysql \
	&& chown -R mysql:mysql /run/mysqld /var/lib/mysql

# config-file
COPY ./config/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./config/init_mariadb.sh /usr/local/bin/init_mariadb.sh
RUN chmod +x /usr/local/bin/init_mariadb.sh

# - metadata/documentation, change noting
EXPOSE 3306

CMD [ "/usr/local/bin/init_mariadb.sh" ]
