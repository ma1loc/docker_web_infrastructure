ARG IMAGE_VERSION=trixie

FROM debian:${IMAGE_VERSION}

RUN apt update -y && apt upgrade -y \
	apt install wordpress curl apache2

# WORKDIR /etc/apache2/sites-available

COPY ./config/wp.conf /etc/apache2/sites-available

CMD [ "wp.sh" ]