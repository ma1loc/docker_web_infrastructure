# instuctions
    # FROM
    # COPY
    # RUN
    # EXPOSE
    # CMD

# first thing first the based image for MariaDB
FROM debian:trixie

# depandences of the MariaDB will done here
# add requrments

RUN sudo apt update -y
RUN sudo apt install mariadb-server -y
# what is this for ?
# RUN sudo mysql_secure_installation
RUN sudo systemctl start mariadb
    
# chose port will be open
EXPOSE 3306

# what is the diffrence between CMD and RUN?
CMD ["mariadbd"]