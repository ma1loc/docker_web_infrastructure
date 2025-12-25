ARG IMAGE_VERSION=trixie

FROM debian:${IMAGE_VERSION}

RUN apt update -y && apt upgrade -y \
	&& apt install -y curl unzip \
	php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-zip

COPY ./config/init_wordpress.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init_wordpress.sh

CMD [ "/usr/local/bin/init_wordpress.sh" ]
