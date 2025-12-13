FROM debian:trixie

<<<<<<< Updated upstream
RUN apt update && apt install -y mariadb-server

RUN mkdir -p /run/mysqld && \
	chown -R mysql:mysql /run/mysqld

EXPOSE 3306

CMD ["mariadbd", "--user=mysql"]
=======
RUN sudo apt update -y
RUN sudo apt install mariadb-server -y

RUN sudo systemctl start mariadb
    
EXPOSE 3306

CMD ["mariadbd"]
>>>>>>> Stashed changes
