ARG IMAGE_VERSION=trixie

FROM debian:${IMAGE_VERSION}

RUN apt update -y && apt upgrade -y \
	&& apt install -y curl unzip \
	php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-zip

RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

COPY ./config/init_wordpress.sh /usr/local/bin/init_wordpress.sh
COPY ./config/www.conf /etc/php/8.4/fpm/pool.d/www.conf

RUN chmod +x /usr/local/bin/init_wordpress.sh

CMD [ "/usr/local/bin/init_wordpress.sh" ]
