ARG IMAGE_VERSION=trixie

FROM debian:${IMAGE_VERSION}

RUN apt update -y && apt upgrade -y \
	apt install -y mariadb-server

# runtime files -> /run/mysqld
# by installing mariadb-server it creates "mysql -> system user", "mysql -> group"
RUN mkdir -p /run/mysqld && \
	chown -R mysql:mysql /run/mysqld

CMD [ "mariadb_setup.sh" ]
